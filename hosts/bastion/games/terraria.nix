{ config, ... }:

{
	sops.secrets.terraria-pw = {
		sopsFile = ./Secrets.yaml;
		owner = "terraria";
		group = "terraria";
		mode = "0400";
		restartUnits = [ "terraria.service" ];
	};
	systemd.services.terraria.serviceConfig.EnvironmentFile =
		config.sops.secrets.terraria-pw.path;
	services.terraria = {
		enable = true;

		dataDir = "/var/lib/terraria";
		port = 7777;
		openFirewall = true;
		password = "$TERRARIA_PASSWORD";

		maxPlayers = 6;
		messageOfTheDay = "terrar";
		autoCreatedWorldSize = "large";
	};
}
