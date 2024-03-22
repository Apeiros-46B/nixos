{ config, pkgs, ... }:

{
	# relatime for /
	fileSystems."/".options = [ "relatime" "lazytime" ];

	# zen kernel
	boot.kernelPackages = pkgs.linuxPackages_zen;
	
	boot.kernelParams = [
		# these will mess with battery life, don't use unless on desktop
		# "intel_idle.max_cstate=1"
		# "rcupdate.rcu_expedited=1"

		"quiet"
		"nowatchdog"
		"nmi_watchdog=0"
		"sysrq_always_enabled=1"
		"amd_iommu=off"
		"intel_iommu=off"
		"mitigations=off"
	];
	
	# use systemd-boot
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;
}
