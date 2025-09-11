{ config, lib, pkgs, ... }:

# Adapted from https://gist.github.com/c0deaddict/1ba67012d857ef541e707e8c8cba163c
let
	cfg = config.my.virtualisation.lxc;
	format = pkgs.formats.json {};
	preseedFile = format.generate "preseed.yaml" cfg.preseed;
in {
	options.my.virtualisation.lxc = {
		enable = lib.mkEnableOption "LXC";

		zfs = {
			enable = lib.mkEnableOption "ZFS support";
			pool = lib.mkOption {
				type = lib.types.str;
				example = "main/local/lxc";
			};
		};

		preseed = lib.mkOption {
			default = {};
			type = format.type;
			example = lib.literalExpression ''
				{
					config = {
						"images.auto_update_interval" = 15;
					};
				};
			'';
			description = ''
				LXD preseed extra configuration. See the documentation for a list of options.
			'';
		};
	};

	config = lib.mkIf cfg.enable {
		my.virtualisation.lxc.preseed = {
			networks = [{
				name = "lxdbr0";
				type = "bridge";
				config = {
					"ipv4.address" = "10.200.0.1/24";
					"ipv6.address" = "fd42::1/64";
				};
			}];
			storage_pools = [{
				name = "default";
				driver = "zfs";
				config.source = cfg.zfs.pool;
			}];
			profiles = [{
				name = "default";
				devices.eth0 = {
					name = "eth0";
					network = "lxdbr0";
					type = "nic";
				};
				devices.root = {
					path = "/";
					pool = "default";
					type = "disk";
				};
			}];
		};

		virtualisation.lxd = {
			enable = true;
			zfsSupport = cfg.zfs.enable;
			recommendedSysctlSettings = true;
		};

		virtualisation.lxc = {
			enable = true;
			lxcfs.enable = true;
			defaultConfig = ''
				lxc.include = ${pkgs.lxcfs}/share/lxc/config/common.conf.d/00-lxcfs.conf
			'';
		};

		systemd.services."lxd-preseed" = {
			description = "Preseed LXD";
			wantedBy = [ "multi-user.target" ];
			requires = [ "lxd.socket" ];
			serviceConfig = {
				Type = "oneshot";
				ExecStart = pkgs.writers.writeDash "preseed" ''
					cat ${preseedFile} | ${pkgs.lxd}/bin/lxd init --preseed
				'';
			};
		};
	};
}
