{ config, lib, pkgs, ... }:

let
	cfg = config.my.services.dufs;
	etcPath = "dufs/config.yaml";
	cfgYaml = (pkgs.formats.yaml {}).generate "config.yaml"
		(lib.attrsets.filterAttrs (k: v: k != "auth") cfg.config);
	makeAccount = with builtins; attrs:
		if (stringLength attrs.user != 0) then
			if (stringLength attrs.passwordFile != 0) then
				"${attrs.user}:$(cat \"${attrs.passwordFile}\" 2> /dev/null)"
			else
				"${attrs.user}"
		else "";
	makeAuthLine = attrs:
		''--auth "${makeAccount attrs}@${attrs.rules}"'';
in {
	options.my.services.dufs = with lib; with lib.types; {
		enable = mkEnableOption "dufs, a file server";
		openFirewall = mkOption {
			type = bool;
			default = true;
		};
		group = mkOption {
			type = str;
			default = "dufs";
		};
		accounts = mkOption {
			type = listOf (submodule {
				options = {
					user = mkOption {
						type = str;
						description = "Username for this user. Leave unset to set rules for guests.";
						default = "";
					};
					passwordFile = mkOption {
						type = str;
						description = ''
							Path to a plain-text secret file containing the password.
							Must be readable by the "dufs" user. Leave unset for no password.
						'';
						default = "";
					};
					rules = mkOption {
						type = str;
						description = "The dufs permission rules for this user.";
						default = "/:ro";
					};
				};
			});
		};
		config = mkOption {
			type = attrsOf anything;
			default = {};
		};
	};

	config = lib.mkIf cfg.enable {
		users.users.dufs = {
			isSystemUser = true;
			packages = [ pkgs.dufs ];
			group = cfg.group;
		};
		users.groups.dufs = {};

		networking.firewall.allowedTCPPorts =
			lib.mkIf cfg.openFirewall [ (cfg.config.port or 5000) ];

		environment.etc.${etcPath}.source = cfgYaml;

		systemd.services.dufs = {
			description = "Start dufs";
			wantedBy = [ "multi-user.target" ];
			wants = [ "network-online.target" ];
			after = [ "network-online.target" ];

			serviceConfig = {
				Type = "simple";
				User = "dufs";
				Group = cfg.group;
				ExecStart = ''
					${pkgs.dufs}/bin/dufs --config /etc/${etcPath} \
						${with builtins; concatStringsSep " " (map makeAuthLine cfg.accounts)}
				'';
			};
			restartTriggers = [ cfgYaml ];
		};
	};
}
