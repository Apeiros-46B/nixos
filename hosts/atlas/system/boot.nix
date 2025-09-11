{ pkgs, ... }:

{
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

}
