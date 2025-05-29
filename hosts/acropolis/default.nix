{ config, lib, pkgs, globals, ... }:

{
	boot.kernelPackages = pkgs.linuxPackages_zen;
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	users.users.${globals.user}.extraGroups = [ "networkmanager" ];
	networking.networkmanager = {
		enable = true;
		insertNameservers = [
			"1.1.1.1"
			"1.0.0.1"
			"8.8.8.8"
		];
	};

	boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "uas" "sd_mod" ];
	boot.initrd.kernelModules = [];
	boot.kernelModules = [ "kvm-intel" ];
	boot.extraModulePackages = [];

	fileSystems."/" = {
		device = "/dev/disk/by-uuid/be20486b-c030-4da4-8b1b-2acf109c2c03";
		fsType = "ext4";
	};

	fileSystems."/boot" = {
		device = "/dev/disk/by-uuid/12CE-A600";
		fsType = "vfat";
		options = [ "fmask=0077" "dmask=0077" ];
	};

	swapDevices = [
		{ device = "/dev/disk/by-uuid/84711563-eb29-4a2b-98ad-752aebfaf030"; }
	];

	networking.useDHCP = lib.mkDefault true;

	nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
	hardware.enableRedistributableFirmware = true;
	hardware.cpu.intel.updateMicrocode = lib.mkDefault true;

	# TODO move out to separate module (maybe factor out to common desktop config)
	services.xserver.videoDrivers = [ "nvidia" ];
	users.users.${globals.user}.extraGroups = [ "video" "render" ];
	hardware = {
		opengl = {
			enable = true;
			enable32Bit = true;
			extraPackages = with pkgs; [
				rocmPackages.clr.icd
			];
		};
		nvidia = {
			open = false;
			package = config.boot.kernelPackages.nvidiaPackages.production
			nvidiaSettings = true;

			modesetting.enable = true;
			powerManagement = {
				enable = false;
				finegrained = false;
			}
			package = config.boot.kernelPackages.nvidiaPackages.stable;
		};
	};
}
