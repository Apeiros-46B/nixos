{ lib, globals, functions, ... }:

let
	makeCloudConfig = attrs: "#cloud-config\n" + (lib.generators.toYAML {} attrs);
	networkIface = "incusbr0";
in {
	systemd.tmpfiles.settings."10-vm-dir" = {
		${globals.dir.vm}.d = {
			user = globals.user;
			group = "users";
			mode = "0755";
		};
	};

	users.users.${globals.user}.extraGroups = [ "incus-admin" ];

	virtualisation.incus = {
		enable = true;
		preseed = {
			profiles = [
				 {
					config = let
						bootstrapPath = "/usr/local/bin/bootstrap.sh";
						socketSetupScriptPath = "/usr/local/bin/socket_setup.sh";
						socketSetupServicePath = "/usr/local/etc/socket_setup.service";
					in {
						"security.nesting" = true;
						"cloud-init.user-data" = makeCloudConfig {
							package_update = true;
							package_upgrade = true;
							package_reboot_if_required = true;
							packages = [
								"git"
								"tmux"
							];
							hostname = "tbots";
							user = {
								name = globals.user;
								uid = globals.uid;
								sudo = [ "ALL=(ALL) NOPASSWD:ALL" ];
								ssh_authorized_keys = [
									"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKlwqbul8KpSr0J7RwZ4yYL/EV7Xka0IdNTywQWwRLGc @tbots#atlas"
								];
							};
							write_files = [
								{
									path = bootstrapPath;
									permissions = "0755";
									content = functions.stripTabs ''
										#!/bin/sh
										default_wants='${globals.home}/.config/systemd/user/default.target.wants'
										name="$(basename '${socketSetupServicePath}')"
										mkdir -p "$default_wants"
										ln -s ${socketSetupServicePath} "$default_wants/$name"
										ln -s ${socketSetupServicePath} "${globals.home}/.config/systemd/user/$name"
										echo 'export DISPLAY=:0' >> ${globals.home}/.profile

										chown -R ${globals.user}:${globals.user} ${globals.home}
									'';
								}
								{
									path = socketSetupScriptPath;
									permissions = "0755";
									content = functions.stripTabs ''
										#!/bin/sh
										tmp_dir=/tmp/.X11-unix
										mkdir -p $tmp_dir
										ln -sf /mnt/.x11_socket $tmp_dir/X0
									'';
								}
								{
									path = socketSetupServicePath;
									content = functions.stripTabs ''
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
							runcmd = [ bootstrapPath ];
						};
					};
					devices = {
						gpu = {
							gid = 44;
							type = "gpu";
						};
						eth0 = {
							name = "eth0";
							network = networkIface;
							type = "nic";
						};
						root = {
							path = "/";
							pool = "default";
							size = "24GiB";
							type = "disk";
						};
						mount = {
							path = "${globals.home}/shared";
							source = globals.dir.vm;
							shift = true;
							type = "disk";
						};
						x11_socket = {
							source = "/tmp/.X11-unix/X0";
							path = "/mnt/.x11_socket";
							type = "disk";
						};
					};
					name = "tbots-base";
				}
			];
			networks = [
				{
					config = {
						"ipv4.address" = "10.0.100.1/24";
						"ipv4.nat" = "true";
					};
					name = networkIface;
					type = "bridge";
				}
			];
			storage_pools = [
				{
					config = {
						source = "/var/lib/incus/storage-pools/tbots-pool";
					};
					driver = "dir";
					name = "tbots-pool";
				}
			];
		};
	};
	networking = {
		nftables.enable = true;
		firewall.trustedInterfaces = [ networkIface ];
		networkmanager.unmanaged = [ networkIface ];
	};
}
