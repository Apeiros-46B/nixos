# TODO: move from ../config/server/services/nas.nix
{ ... }: {}
# { config, pkgs, ... }:

# with pkgs.lib;
# let
# 	cfg = config.my.services.dufs;
	
# in {
# 	options.my.services.dufs = {
# 		enable = mkEnableOption "dufs, a file server";
# 		directory = mkOption {
# 			type = "str";
# 			default = "/dufs";
# 		};
# 	};

# 	config = mkIf cfg.enable {
# 		systemd.services.dufs = {
# 			description = "Start dufs";
# 			wants = [ "network-online.target" ];
# 			after = [ "network-online.target" ];

# 			serviceConfig = {
# 				Type = "simple";
# 				User = "dufs";
# 				ExecStart = "${pkgs.dufs}/bin/dufs --config /etc/dufs/config.yaml";
# 			};
# 		};
# 	};
# }
