# Thinkpad p15v gen 2
{ lib, pkgs, ... }:
# TODO: restructure to similar form as hosts/bastion/ and config/*/

{
	imports = [
		./backlight.nix
		./bluetooth.nix
		./display.nix
		./fingerprint.nix
		./gpu.nix
		./keyd.nix
		./power.nix
		./wifi.nix
	];

	# zen kernel
	boot.kernelPackages = pkgs.linuxPackages_zen;
	boot.initrd.availableKernelModules = [
		"xhci_pci"
		"thunderbolt"
		"nvme"
		"usb_storage"
		"sd_mod"
		"rtsx_pci_sdmmc"
	];
	boot.initrd.kernelModules = [];
	boot.kernelModules = [];
	boot.extraModulePackages = [];

	fileSystems."/" = {
		device = "/dev/disk/by-uuid/bdb03842-5d4c-4a18-b9c7-f6c2e6b84c07";
		fsType = "ext4";
		options = [ "relatime" "lazytime" ];
	};
	fileSystems."/boot" = {
		device = "/dev/disk/by-uuid/E6D4-BA29";
		fsType = "vfat";
	};
	swapDevices = [{
		device = "/dev/disk/by-uuid/8d1f6e55-db2d-43ad-b7b4-a0799e8d27e5";
	}];

	hardware.enableRedistributableFirmware = true;
	hardware.cpu.intel.updateMicrocode = lib.mkDefault true;
	networking.useDHCP = lib.mkDefault true;
}
