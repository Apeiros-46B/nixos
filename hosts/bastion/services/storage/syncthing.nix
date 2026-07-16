{ config, globals, ... }:

let
	tsDomain = "st.${globals.net.tsDomain}";
in {
	# make newly created folders/files 0750/0640 when Ignore Permissions is set
	systemd.services.syncthing.serviceConfig.UMask = "0027";

	my.services.rproxy.tsDomains.${tsDomain} = 8384;

	sops.secrets.syncthing-gui-password = {
		sopsFile = ./Secrets.yaml;
		owner = "syncthing";
		group = "syncthing";
		mode = "0400";
		restartUnits = [ "syncthing.service" ];
	};

	services.syncthing = {
		enable = true;
		# we don't use the dataDir so don't need to set it
		guiAddress = "0.0.0.0:8384";
		guiPasswordFile = config.sops.secrets.syncthing-gui-password.path;
		settings = {
			devices = {
				acropolis.id = "K355HSY-FXG4ENF-UZ2Q3N2-IWBPBJN-4K5EV7W-IZK53QA-C7XXU52-STNEQQJ";
				atlas.id = "XG3HCKD-YP3UNY6-FRU7PW4-YWY52E7-RMGMASW-HE4FZ56-2BIVX57-MGTI5AY";
				phone.id = "M33EP75-6QYMAYN-LHK4VKK-SSVZ4WH-XW7CTLQ-JJH3IN7-WU4XGYR-JWXLIA4";
			};
			folders = {
				music = {
					id = "53ln6-dw9cy";
					path = "/nas/music";
					type = "receiveonly";
					devices = [
						"acropolis"
						"atlas"
					];
					ignorePatterns = [ ".hist" ]; # copyparty files
					ignorePerms = true;
				};
			};
		};
	};
}
