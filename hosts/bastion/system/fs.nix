{ ... }:

{
	networking.hostId = "d5f1bf16";

	boot = {
		supportedFilesystems = [ "btrfs" "zfs" ];
		initrd = {
			supportedFilesystems = [ "zfs" ];
			kernelModules = [ "zfs" ];
			systemd.enable = true;
		};
		zfs = {
			forceImportAll = false;
			forceImportRoot = true;
		};
	};

	virtualisation.docker = {
		storageDriver = "zfs";
		daemon.settings.data-root = "/mnt/docker";
	};

	# TODO: somehow share dir pathnames between this and the actual config modules
	# TODO: declarative zfs config with disko-zfs
	fileSystems = {
		"/"     = { device = "nixos/root"; fsType = "zfs"; };
		"/nix"  = { device = "nixos/nix";  fsType = "zfs"; };
		"/srv"  = { device = "nixos/srv";  fsType = "zfs"; };
		"/var"  = { device = "nixos/var";  fsType = "zfs"; };
		"/home" = { device = "nixos/home"; fsType = "zfs"; };

		"/mnt/docker" = { device = "nixos/docker"; fsType = "zfs"; };
		"/mnt/media"  = { device = "nixos/media";  fsType = "zfs"; };
		"/mnt/nas"    = { device = "nixos/nas";    fsType = "zfs"; };

		"/boot" = {
			device = "/dev/disk/by-uuid/DAFE-74C0";
			fsType = "vfat";
			options = [ "fmask=0022" "dmask=0022" "umask=0077" ];
		};

		# TODO: fill in once reformatted and UUID is found
		# "/mnt/lacie" = {
		# 	device = "/dev/disk/by-uuid/XXXX-XXXX";
		# 	fsType = "btrfs";
		# 	options = [
		# 		"defaults"
		# 		"nofail"
		# 		"compress=zstd"
		# 		"autodefrag"
		# 		"x-systemd.automount"
		# 		"x-systemd.idle-timeout=600"
		# 	];
		# };
	};

	swapDevices = [{
		device = "/dev/nvme0n1p2";
	}];
}
