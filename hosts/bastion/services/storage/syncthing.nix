{ config, globals, ... }:

let
	tsDomain = "st.${globals.net.tsDomain}";
in {
	my.services.rproxy.tsDomains.${tsDomain} = 8384;

	sops.secrets.syncthing-gui-password = {
		sopsFile = ./Secrets.yaml;
		owner = "syncthing";
		group = "nas";
		mode = "0400";
		restartUnits = [ "syncthing.service" ];
	};

	# make newly created folders have 0770 or 0660 when Ignore Permissions is set
	systemd.services.syncthing.serviceConfig.UMask = "0007";

	# already enabled in common/services/syncthing.nix
	services.syncthing = {
		group = "nas";
		# we don't use the dataDir so don't need to set it
		guiAddress = "0.0.0.0:8384";
		guiPasswordFile = config.sops.secrets.syncthing-gui-password.path;
		overrideDevices = false;
		overrideFolders = false;
		settings = {
			devices = {
				acropolis.id = "K355HSY-FXG4ENF-UZ2Q3N2-IWBPBJN-4K5EV7W-IZK53QA-C7XXU52-STNEQQJ";
				phone.id = "M33EP75-6QYMAYN-LHK4VKK-SSVZ4WH-XW7CTLQ-JJH3IN7-WU4XGYR-JWXLIA4";
			};
			folders = {
				music = {
					id = "53ln6-dw9cy";
					path = "/nas/music";
					ignorePatterns = [ ".hist" ];
					copyOwnershipFromParent = true;
					devices = [
						"acropolis"
					];
				};
				music_mirror = {
					id = "6rnu7-zfrn5";
					path = "/nas/mirror/music";
					type = "sendonly";
					devices = [
						"phone"
					];
				};
			};
		};
	};
}
