{ pkgs, ... }:

{
	networking.hostId = "d5f1bf16";

	boot = {
		supportedFilesystems = [ "zfs" ];
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
	
	fileSystems = {
		"/"     = { device = "nixos/root"; fsType = "zfs"; };
		"/nix"  = { device = "nixos/nix";  fsType = "zfs"; };
		"/var"  = { device = "nixos/var";  fsType = "zfs"; };
		"/home" = { device = "nixos/home"; fsType = "zfs"; };
		"/nas"  = { device = "nixos/nas";  fsType = "zfs"; };
		"/boot" = {
			device = "/dev/disk/by-uuid/DAFE-74C0";
			fsType = "vfat";
			options = [ "fmask=0022" "dmask=0022" "umask=0077" ];
		};
	};

	swapDevices = [{
		device = "/dev/nvme0n1p2";
	}];
}
