{ config, pkgs, ... }:

with pkgs.lib;
let
	cfg = config.my.services.dufs;
	
in {
	options.my.services.dufs = {
		enable = mkEnableOption "dufs, a file server";
		config = mkOption {
			type = attrsOf inferred;
			default = {};
		};
	};

	config = mkIf cfg.enable {
		systemd.services.dufs = {
			description = "Start dufs";
			wantedBy = [ "multi-user.target" ];
			wants = [ "network-online.target" ];
			after = [ "network-online.target" ];

			serviceConfig = {
				Type = "simple";
				User = "dufs";
				Group = "dufs";
				ExecStart = "${pkgs.dufs}/bin/dufs --config /etc/dufs/config.yaml";
			};
		};

		environment.etc."dufs/config.yaml".text =
			(pkgs.formats.yaml {}).generate "config.yaml" cfg.config;
	};
}
