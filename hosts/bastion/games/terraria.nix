{ config, ... }:

{
	sops.secrets = {
		terraria-pw = {
			sopsFile = ./Secrets.yaml;
			owner = "terraria";
			group = "terraria";
			mode = "0400";
			restartUnits = [ "terraria.service" ];
		};
	};
	systemd.services.terraria.serviceConfig.EnvironmentFile =
		config.sops.secrets.terraria-pw.path;
	services.terraria = rec {
		enable = true;

		dataDir = "/var/lib/terraria";
		worldPath = "${dataDir}/world.wld";
		banListPath = "${dataDir}/banned.txt";

		port = 7777;
		openFirewall = false;
		password = "$TERRARIA_PASSWORD";

		maxPlayers = 6;
		messageOfTheDay = "terrar";
		autoCreatedWorldSize = "large";
	};
}
