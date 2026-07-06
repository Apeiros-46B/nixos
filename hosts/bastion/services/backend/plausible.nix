{ config, lib, globals, ... }:

let
	port = 8001;
	pubDomain = "plausible.${globals.net.pubDomain}";
	tsDomain = "plausible.${globals.net.tsDomain}";
in {
	my.services.rproxy = {
		domains.${pubDomain} = port;
		tsDomains.${tsDomain} = port;
	};

	sops.secrets.plausible-secret-keybase = {
		sopsFile = ./Secrets.yaml;
		owner = "root"; # loaded by systemd LoadCredential
		group = "root";
		mode = "0400";
		restartUnits = [ "plausible.service" ];
	};

	services.plausible = {
		enable = true;
		server = {
			port = port;
			listenAddress = "127.0.0.1";
			baseUrl = "https://${tsDomain}"; # fixes dashboard cross-origin issues
			disableRegistration = false;
			secretKeybaseFile = config.sops.secrets.plausible-secret-keybase.path;
		};
	};

	services.nginx.virtualHosts.${tsDomain}.locations."/" = {
		proxyPass = "http://127.0.0.1:${toString port}";
		proxyWebsockets = true; # login and dashboard things require websockets
	};

	# override rproxy to rewrite and hide dashboard
	services.nginx.virtualHosts.${pubDomain} = {
		# don't show dashboard
		locations."/" = lib.mkForce {
			return = "404";
		};

		# rewrite script name
		locations."= /assets/main.js" = {
			proxyPass = "http://127.0.0.1:${toString port}/js/script.outbound-links.js";
		};

		# telemetry endpoint
		locations."= /main" = {
			proxyPass = "http://127.0.0.1:${toString port}/api/event";
		};
	};
}
