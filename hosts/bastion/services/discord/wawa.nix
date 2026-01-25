{ config, ... }:

{
	sops.secrets.wawa-discord-token-env = {
		sopsFile = ./Secrets.yaml;
		owner = "root";
		group = "root";
		mode = "0400";
		restartUnits = [ "wawa.service" ];
	};
	my.services.wawa = {
		enable = false;
		tokenEnvFile = config.sops.secrets.wawa-discord-token-env.path;
		extraEnv = ''
			BOT_SELF_ID=1304859603191857284
			BOT_SELF_HANDLE="wawa#1526"
		'';
	};
}
