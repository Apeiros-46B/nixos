{ ... }:

{
	fileSystems = {
		"/" = {
			device = "/dev/disk/by-uuid/bdb03842-5d4c-4a18-b9c7-f6c2e6b84c07";
			fsType = "ext4";
			options = [ "relatime" "lazytime" ];
		};
		"/boot" = {
			device = "/dev/disk/by-uuid/E6D4-BA29";
			fsType = "vfat";
		};
	};

	swapDevices = [{
		device = "/dev/disk/by-uuid/8d1f6e55-db2d-43ad-b7b4-a0799e8d27e5";
	}];
}
