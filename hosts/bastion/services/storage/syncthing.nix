{ config, globals, ... }:

let
	tsDomain = "st.${globals.net.tsDomain}";
in {
	# TODO SYNCTHING 01.30
	# - Issue 1: GUI password prompt either doesn't appear properly or has the wrong password. https://gemini.google.com/u/5/app/56fc94da4b4d99cf?pageId=none
	# - Issue 2: The dataDir option overrides permissions for /nas; it is mode 700 and owned by syncthing. What would be better is have /nas/sync, and then you point dataDir = /nas/sync, and then inside /nas/sync you have music mirror and a SYMLINK to the lossless music volume

	sops.secrets.syncthing-gui-password = {
		sopsFile = ./Secrets.yaml;
		owner = "syncthing";
		group = "nas";
		mode = "0400";
		restartUnits = [ "syncthing.service" ];
	};

	# already enabled in common/services/syncthing.nix
	services.syncthing = {
		group = "nas";
		dataDir = "/nas";
		settings.gui = {
			user = "admin";
			passwordFile = config.sops.secrets.syncthing-gui-password.path;
		};
		# guiAddress = "0.0.0.0:8384";
	};

	services.nginx.virtualHosts.${tsDomain} = {
		useACMEHost = globals.net.tsDomain;
		forceSSL = true;
		locations."/" = {
			proxyPass = "http://${config.services.syncthing.guiAddress}";
			proxyWebsockets = true;
			extraConfig = ''
				proxy_buffering off;
				client_max_body_size 0;
			'';
		};
	};
}
