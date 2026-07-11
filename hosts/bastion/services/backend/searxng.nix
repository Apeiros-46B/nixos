{ config, globals, ... }:

let
	port = 8888;
in {
	sops.secrets.searxng-env-file = {
		sopsFile = ./Secrets.yaml;
		owner = "root";
		group = "root";
		mode = "0400";
	};

	my.services.rproxy.tsDomains."search.${globals.net.tsDomain}" = port;

	# TODO: services.searx.openFirewall does not exist yet on my nixpkgs version
	networking.firewall.allowedTCPPorts = [ port ];

	# internal use only, no need for ratelimiting or uwsgi
	services.searx = {
		enable = true;
		# openFirewall = true;
		environmentFile = config.sops.secrets.searxng-env-file.path;
		settings = {
			server = {
				inherit port;
				bind_address = "0.0.0.0";
				secret_key = "$SEARX_SECRET_KEY";
				limiter = false;
			};
			# go my slop swarm
			search.formats = [ "html" "json" ];
		};
	};
}
