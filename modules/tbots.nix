{ config, lib, functions, ... }:

let
	cfg = config.my.containers.tbots;
	makeCloudConfig = attrs: "#cloud-config\n" + (lib.generators.toYAML {} attrs);
	stripTabs = functions.stripTabs;
in {
	options.my.containers.tbots = with lib.types; {
		enable = lib.mkEnableOption "Thunderbots development environment (Incus container)";
		user = lib.mkOption { type = str; };
		dataDir = lib.mkOption { type = str; };
		uid = lib.mkOption {
			type = int;
			default = 1000;
		};
		x11Display = lib.mkOption {
			type = int;
			default = 0;
		};
		waylandDisplay = lib.mkOption {
			type = int;
			default = 0;
		};
		packages = lib.mkOption {
			type = listOf str;
			default = [];
		};
		envExtra = lib.mkOption {
			type = str;
			default = "";
		};
		bashrcExtra = lib.mkOption {
			type = str;
			default = "";
		};
		hostname = lib.mkOption {
			type = str;
			default = "tbots";
		};
		profileName = lib.mkOption {
			type = str;
			default = "tbots-base";
		};
		poolName = lib.mkOption {
			type = str;
			default = "tbots-pool";
		};
		networkName = lib.mkOption {
			type = str;
			default = "incusbr0";
		};
	};

	config = lib.mkIf cfg.enable {
		users.users.root = {
			subUidRanges = [ { startUid = cfg.uid; count = 1; } ];
			subGidRanges = [ { startGid = cfg.uid; count = 1; } ];
		};

		systemd.tmpfiles.settings."10-tbots-shared-dir" = {
			${cfg.dataDir}.d = {
				user = cfg.user;
				group = "users";
				mode = "0755";
			};
		};

		users.users.${cfg.user}.extraGroups = [ "incus-admin" ];

		virtualisation.incus = {
			enable = true;
			preseed = {
				profiles = [
					{
						config = let
							bashrcPath = "/usr/local/bin/bashrc_extra.sh";
							initScriptPath = "/usr/local/bin/bootstrap.sh";
							socketSetupScriptPath = "/usr/local/bin/socket_setup.sh";
							socketSetupServicePath = "/usr/local/etc/socket_setup.service";
						in {
							"raw.idmap" = "both ${toString cfg.uid} 1000";
							"security.nesting" = true;
							"cloud-init.user-data" = makeCloudConfig {
								package_update = true;
								package_upgrade = true;
								package_reboot_if_required = true;
								packages = [
									{
										apt = cfg.packages ++ [
											"gcc"
											"make"
											"git"
											"wget"
											"openssh-client"
											"xclip"
											"wl-clipboard"
										];
									}
								];
								hostname = cfg.hostname;
								user = {
									name = cfg.user;
									sudo = [ "ALL=(ALL) NOPASSWD:ALL" ];
									groups = [ "video" "render" ];
								};
								write_files = [
									{
										path = "/etc/profile.d/02-env-vars.sh";
										content = stripTabs (''
											export TERM=xterm-256color
											export DISPLAY=:${toString cfg.x11Display}
											export WAYLAND_DISPLAY=wayland-${toString cfg.waylandDisplay}
											export XDG_SESSION_TYPE=wayland
											export QT_QPA_PLATFORM=wayland
										'' + "\n" + cfg.envExtra);
									}
									{
										path = bashrcPath;
										content = stripTabs cfg.bashrcExtra;
									}
									{
										path = initScriptPath;
										permissions = "0755";
										content = stripTabs ''
											#!/bin/sh
											echo 'source "${bashrcPath}"' >> /etc/bash.bashrc
											echo 'source "${bashrcPath}"' >> /root/.bashrc
											home="/home/${cfg.user}"
											default_wants="$home/.config/systemd/user/default.target.wants"
											name="$(basename '${socketSetupServicePath}')"
											mkdir -p "$default_wants"
											ln -s ${socketSetupServicePath} "$default_wants/$name"
											ln -s ${socketSetupServicePath} "$home/.config/systemd/user/$name"
											chown -R ${cfg.user}:${cfg.user} $home
										'';
									}
									{
										path = socketSetupScriptPath;
										permissions = "0755";
										content = stripTabs ''
											#!/bin/sh
											uid=$(id -u)
											tmp_dir=/tmp/.X11-unix
											run_dir=/run/user/$uid
											mkdir -p $tmp_dir
											mkdir -p $run_dir && chmod 700 $run_dir && chown $uid:$uid $run_dir
											ln -sf /mnt/.x11_socket $tmp_dir/X${toString cfg.x11Display}
											ln -sf /mnt/.wayland_socket $run_dir/wayland-${toString cfg.waylandDisplay}
										'';
									}
									{
										path = socketSetupServicePath;
										content = stripTabs ''
											[Unit]
											After=local-fs.target
											[Service]
											Type=oneshot
											ExecStart=/usr/local/bin/socket_setup.sh
											[Install]
											WantedBy=default.target
										'';
									}
								];
								runcmd = [ initScriptPath ];
							};
						};
						devices = {
							gpu = {
								gid = 44;
								type = "gpu";
							};
							root = {
								path = "/";
								pool = cfg.poolName;
								size = "24GiB";
								type = "disk";
							};
							mount = {
								path = "/home/${cfg.user}/shared";
								source = cfg.dataDir;
								shift = true;
								type = "disk";
							};
							x11_socket = {
								source = "/tmp/.X11-unix/X${toString cfg.x11Display}";
								path = "/mnt/.x11_socket";
								type = "disk";
							};
							wayland_socket = {
								source = "/run/user/${toString cfg.uid}/wayland-${toString cfg.waylandDisplay}";
								path = "/mnt/.wayland_socket";
								type = "disk";
							};
							eth0 = {
								name = "eth0";
								network = cfg.networkName;
								type = "nic";
							};
							gc_proxy = {
								connect = "tcp:127.0.0.1:8081";
								listen = "tcp:127.0.0.1:8081";
								type = "proxy";
							};
						};
						name = cfg.profileName;
					}
				];
				storage_pools = [
					{
						config = {
							source = "/var/lib/incus/storage-pools/${cfg.poolName}";
						};
						driver = "dir";
						name = cfg.poolName;
					}
				];
				networks = [
					{
						config = {
							"ipv4.address" = "10.0.100.1/24";
							"ipv4.nat" = "true";
						};
						name = cfg.networkName;
						type = "bridge";
					}
				];
			};
		};
		networking = {
			nftables.enable = true;
			firewall.trustedInterfaces = [ cfg.networkName ];
			networkmanager.unmanaged = [ cfg.networkName ];
		};
	};
}
