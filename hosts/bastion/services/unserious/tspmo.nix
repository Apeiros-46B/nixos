{ config, inputs, globals, ... }:

let
	port = 9001;
	domain = "tspmo.${globals.net.pubDomain}";
in {
	imports = [ inputs.tspmo.nixosModules.default ];

	my.services.rproxy.domains.${domain} = port;

	sops.secrets.tspmo-secrets-json = {
		sopsFile = ./Secrets.yaml;
		owner = "root";
		group = "root";
		mode = "0400";
		restartUnits = [ "tspmo-board.service" "tspmo-bot.service" ];
	};

	services.tspmo = {
		enable = true;
		secretsFile = config.sops.secrets.tspmo-secrets-json.path;
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

			rootUsername = globals.discord.name;
			rootDiscordId = globals.discord.uid;
			homeGuildId = "1447278647168729100";
			adminRoleIds = [ "1478921450772496566" ];
			modRoleIds = [ "1478921421832060960" ];
			userRoleIds = [
				"1478921382032052306" # bowen
				"1479488092258963509" # terrahelsia
				"1480695854225555477" # (tar)
			];
		};
	};
}
