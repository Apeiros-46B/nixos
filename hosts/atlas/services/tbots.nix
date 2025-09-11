{ inputs, pkgs, globals, ... }:

let
	networkIface = "incusbr0";
	# {{{
	nixvirt = inputs.nixvirt;

	domain_name = "tbots-ubuntu";
	pool_name = "linux-vm";
	volume_name = "${domain_name}.qcow2";

	domain = nixvirt.lib.domain.writeXML (nixvirt.lib.domain.templates.linux {
		name = domain_name;
		uuid = "bec3cac4-b2a4-4e59-b079-3219fb7ba3c8";
		memory = { count = 8; unit = "GiB"; };
		storage_vol = { pool = pool_name; volume = volume_name; };
		install_vol = "${pkgs.my.ubuntu-server}/installer.iso";
		virtio_video = null;
	});
	network = nixvirt.lib.network.writeXML (nixvirt.lib.network.templates.bridge {
		uuid = "70b08691-28dc-4b47-90a1-45bbeac9ab5a";
		subnet_byte = 16;
	});
	pool = nixvirt.lib.pool.writeXML {
		name = pool_name;
		uuid = "650c5bbb-eebd-4cea-8a2f-36e1a75a8683";
		type = "dir";
		target = { path = "${globals.dir.vm}/${pool_name}"; };
	};
	volume = nixvirt.lib.volume.writeXML {
		name = domain_name;
		capacity = { count = 24; unit = "GB"; };
	};
	# }}}
in {
	# {{{
	# imports = [
	# 	nixvirt.nixosModules.default
	# ];
	#
	# virtualisation.libvirt = {
	# 	enable = true;
	# 	connections."qemu:///session" = {
	# 		domains = [
	# 			{ definition = domain; }
	# 		];
	# 		networks = [
	# 			{
	# 				active = true;
	# 				definition = network;
	# 			}
	# 		];
	# 		pools = [
	# 			{
	# 				active = true;
	# 				definition = pool;
	# 				volumes = [
	# 					{
	# 						present = true;
	# 						definition = volume;
	# 					}
	# 				];
	# 			}
	# 		];
	# 	};
	# };
	# }}}

	users.users.${globals.user}.extraGroups = [ "incus-admin" ];
	virtualisation.incus = {
		enable = true;
		preseed = {
			profiles = [
				{
					config = {
						"environment.DISPLAY" = ":0";
						"user.user-data" = "packages:\n  - x11-apps\n  - mesa-utils";
					};
					devices = {
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
						X0 = {
							bind = "container";
							type = "proxy";
							connect = "unix:@/tmp/.X11-unix/X0";
							listen = "unix:@/tmp/.X11-unix/X0";
							"security.uid" = 1000;
							"security.gid" = 100;
						};
						gpu = { type = "gpu"; };
					};
					name = "default-gui";
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
						source = "/var/lib/incus/storage-pools/default";
					};
					driver = "dir";
					name = "default";
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
