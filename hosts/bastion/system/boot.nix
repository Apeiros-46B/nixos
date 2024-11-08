{ ... }:

{
	boot = {
		kernelModules = [ "kvm-intel" ];
		extraModulePackages = [];
		initrd.availableKernelModules = [
			"xhci_pci"
			"ahci"
			"nvme"
			"usbhid"
			"uas"
			"sd_mod"
		];
	};
}
