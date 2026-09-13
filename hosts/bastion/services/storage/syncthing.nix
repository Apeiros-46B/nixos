{ config, globals, ... }:

let
	tsDomain = "sync.${globals.net.tsDomain}";
	port = 8384;
in {
	# make newly created folders/files 0750/0640 when Ignore Permissions is set
	systemd.services.syncthing.serviceConfig.UMask = "0027";

	my.services.rproxy.tsDomains.${tsDomain} = 8384;

	sops.secrets.syncthing-gui-password = {
		sopsFile = ./Secrets.yaml;
		owner = "syncthing";
		group = "prometheus";
		mode = "0440";
		restartUnits = [ "syncthing.service" "prometheus.service" ];
	};

	# $STGUIAPIKEY
	sops.secrets.syncthing-api-key-env = {
		sopsFile = ./Secrets.yaml;
		owner = "syncthing";
		group = "grafana";
		mode = "0440";
		restartUnits = [ "syncthing.service" "grafana.service" ];
	};
	systemd.services.syncthing.serviceConfig.EnvironmentFile = [
		config.sops.secrets.syncthing-api-key-env.path
	];

	services.syncthing = {
		enable = true;
		# we don't use the dataDir so don't need to set it
		guiAddress = "0.0.0.0:${toString port}";
		guiPasswordFile = config.sops.secrets.syncthing-gui-password.path;
		settings = {
			gui.user = "admin";
			devices = {
				acropolis = {
					id = "K355HSY-FXG4ENF-UZ2Q3N2-IWBPBJN-4K5EV7W-IZK53QA-C7XXU52-STNEQQJ";
					addresses = [ "dynamic" "tcp://100.91.81.53:22000" ];
				};
				atlas = {
					id = "XG3HCKD-YP3UNY6-FRU7PW4-YWY52E7-RMGMASW-HE4FZ56-2BIVX57-MGTI5AY";
					compression = "always";
					addresses = [ "dynamic" "tcp://100.75.158.42:22000" ];
				};
				phone = {
					id = "M33EP75-6QYMAYN-LHK4VKK-SSVZ4WH-XW7CTLQ-JJH3IN7-WU4XGYR-JWXLIA4";
					compression = "always";
					addresses = [ "dynamic" "tcp://100.78.187.98:22000" ];
				};
			};
			folders.sync = {
				id = "ycwnf-d7xrk";
				path = "/mnt/nas/sync";
				type = "sendreceive";
				devices = [ "phone" ];
				ignorePatterns = [ ".hist" ];
				ignorePerms = true;
			};
		};
	};

	services.prometheus.scrapeConfigs = [
		{
			job_name = "syncthing";
			basic_auth = {
				username = "admin";
				password_file = config.sops.secrets.syncthing-gui-password.path;
			};
			static_configs = [{
				targets = [ "localhost:${toString port}" ];
			}];
		}
	];
}
