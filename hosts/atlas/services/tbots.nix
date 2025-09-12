{ lib, globals, functions, ... }:

let
	makeCloudConfig = attrs: "#cloud-config\n" + (lib.generators.toYAML {} attrs);
	networkIfaceName = "incusbr0";
	storagePoolName = "tbots-pool";
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
						bashrcPath = "/usr/local/bin/bashrc_extra.sh";
						initScriptPath = "/usr/local/bin/bootstrap.sh";
						socketSetupScriptPath = "/usr/local/bin/socket_setup.sh";
						socketSetupServicePath = "/usr/local/etc/socket_setup.service";
					in {
						"security.nesting" = true;
						"cloud-init.user-data" = makeCloudConfig {
							package_update = true;
							package_upgrade = true;
							package_reboot_if_required = true;
							packages = [ { apt = [ "git" "tree" "tmux" "wget" "openssh-client" ]; } ];
							hostname = "tbots";
							user = {
								name = globals.user;
								uid = globals.uid;
								sudo = [ "ALL=(ALL) NOPASSWD:ALL" ];
							};
							write_files = [
								{
									path = "/etc/profile.d/02-env-vars.sh";
									content = functions.stripTabs ''
										export TERM=xterm-256color
										export DISPLAY=:0
										eval "$(dircolors -b)"
									'';
								}
								{
									path = bashrcPath;
									content = functions.stripTabs ''
										alias ls='ls -F --color=auto --group-directories-first'
										alias la='ls -A'
										alias ll='ls -lh'
										alias l='ls -lAh'
										alias tree='tree --dirsfirst'
										launch() {
											"$@" > /dev/null 2>&1 & disown
										}
										prompt_accent() {
											if [ $? -ne 0 ]; then
												tput setab 1
											elif [ "$(whoami)" = root ]; then
												tput setab 5
											else
												tput setab 4
											fi
										}
										PS1='$(prompt_accent) $(tput setab 8) \h.\w $(tput sgr0) '
									'';
								}
								{
									path = initScriptPath;
									permissions = "0755";
									content = functions.stripTabs ''
										#!/bin/sh
										echo 'source "${bashrcPath}"' >> /etc/bash.bashrc
										echo 'source "${bashrcPath}"' >> /root/.bashrc
										default_wants='${globals.home}/.config/systemd/user/default.target.wants'
										name="$(basename '${socketSetupServicePath}')"
										mkdir -p "$default_wants"
										ln -s ${socketSetupServicePath} "$default_wants/$name"
										ln -s ${socketSetupServicePath} "${globals.home}/.config/systemd/user/$name"
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
							runcmd = [ initScriptPath ];
						};
					};
					devices = {
						gpu = {
							gid = 44;
							type = "gpu";
						};
						eth0 = {
							name = "eth0";
							network = networkIfaceName;
							type = "nic";
						};
						root = {
							path = "/";
							pool = storagePoolName;
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
					name = networkIfaceName;
					type = "bridge";
				}
			];
			storage_pools = [
				{
					config = {
						source = "/var/lib/incus/storage-pools/${storagePoolName}";
					};
					driver = "dir";
					name = storagePoolName;
				}
			];
		};
	};
	networking = {
		nftables.enable = true;
		firewall.trustedInterfaces = [ networkIfaceName ];
		networkmanager.unmanaged = [ networkIfaceName ];
	};
}
