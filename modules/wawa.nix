{ system, inputs, config, lib, ... }:

let
	cfg = config.my.services.wawa;
	logDir = "/var/log/wawa";
	dataDir = "/var/lib/wawa";
in {
	options.my.services.wawa = with lib; {
		enable = mkEnableOption "wawa, the Uiua discord bot";
		tokenEnvFile = mkOption {
			type = types.str;
			description = "Path to a file containing one line: 'DISCORD_TOKEN=<token here>'";
		};
		extraEnv = mkOption {
			type = types.lines;
			description = "Other environment variables to pass to the bot.";
			default = "";
		};
	};

	config = lib.mkIf cfg.enable {
		systemd.tmpfiles.settings."10-wawa" = {
			"${logDir}".d = {
				user  = "root";
				group = "root";
				mode  = "0755";
				age   = "7d";
			};
			${dataDir}.d = {
				user  = "root";
				group = "root";
				mode  = "0755";
			};
			"${dataDir}/.env".f = {
				user  = "root";
				group = "root";
				mode  = "0700";
				argument = cfg.extraEnv + "\n" + ''
					LOGS_DIRECTORY=${logDir}
				'';
			};
		};

		systemd.services.wawa = {
			description = "Uiua discord bot";
			wantedBy    = [ "multi-user.target" ];
			wants       = [ "network-online.target" ];
			after       = [ "network-online.target" ];

			# TODO: the package currently doesn't build
			serviceConfig = {
				EnvironmentFile = cfg.tokenEnvFile;
				ExecStart = "${inputs.wawa.packages.${system}.default}/bin/wawa";
				Restart = "on-failure";
			};
		};
	};
}
