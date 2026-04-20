{ config, inputs, globals, ... }:

let
	port = 3000;
	domain = "tspmo.${globals.net.pubDomain}";
in {
	imports = [ inputs.tspmo.nixosModules.default ];

	sops.secrets.tspmo-secrets-json = {
		sopsFile = ./Secrets.yaml;
		owner = "root";
		group = "root";
		mode = "0400";
		restartUnits = [ "tspmo-board.service" "tspmo-bot.service" ];
	};

	services.tspmo = {
		enable = true;
		settings = {
			boardPort = port;
			boardHost = "http://localhost";
			allowedBotIPs = [
				"127.0.0.1"
				"::1"
				"::ffff:127.0.0.1"
			];
			discordClientId = "1462192527405748345";

			serviceName = "tspmo";
			externalURL = "https://${domain}";

			postMaxSizeMB = 127;

			dataPath = "/var/lib/tspmo";

			rootUsername = "apei.ros";
			rootDiscordId = "443604304264429578";
			homeGuildId = "1447278647168729100";
			adminRoleIds = [ "1478921450772496566" ];
			modRoleIds = [ "1478921421832060960" ];
			userRoleIds = [
				"1478921382032052306" # bowen
				"1479488092258963509" # terrahelsia
				"1480695854225555477" # (tar)
			];
		};
		secretsFile = config.sops.secrets.tspmo-secrets-json.path;
	};

	my.services.rproxy.domains.${domain} = port;

	# services.nginx.virtualHosts."tspmo.apeiros.xyz" = {
	# 	useACMEHost = globals.net.pubDomain;
	# 	forceSSL = true;
	# 	listen = [
	# 		{ addr = "0.0.0.0"; port = 443; ssl = true; }
	# 		{ addr = "127.0.0.1"; port = 4443; ssl = true; extraParameters = [ "proxy_protocol" ]; }
	# 	];
	# 	locations."/" = {
	# 		proxyPass = "http://10.0.0.21:3000";
	# 
	# 		proxyWebsockets = true;
	# 		extraConfig = ''
	# 			proxy_buffering off;
	# 			client_max_body_size 0;
	# 			proxy_set_header X-Real-IP $remote_addr;
	# 			proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
	# 		'';
	# 	};
	# };
}
