{ config, lib, pkgs, ... }:

let
	cfg = config.my.services.dufs;
	etcPath = "dufs/config.yaml";
in {
	options.my.services.dufs = with lib; {
		enable = mkEnableOption "dufs, a file server";
		openFirewall = mkOption {
			type = types.bool;
			default = true;
		};
		group = mkOption {
			type = types.str;
			default = "dufs";
		};
		config = mkOption {
			type = types.attrsOf types.anything;
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

		systemd.services.dufs = {
			description = "Start dufs";
			wantedBy = [ "multi-user.target" ];
			wants = [ "network-online.target" ];
			after = [ "network-online.target" ];

			serviceConfig = {
				Type = "simple";
				User = "dufs";
				Group = cfg.group;
				ExecStart = "${pkgs.dufs}/bin/dufs --config /etc/${etcPath}";
			};
		};

		environment.etc.${etcPath}.source =
			(pkgs.formats.yaml {}).generate "config.yaml" config.my.services.dufs.config;

		networking.firewall.allowedTCPPorts =
			lib.mkIf cfg.openFirewall [ (cfg.config.port or 5000) ];
	};
}
