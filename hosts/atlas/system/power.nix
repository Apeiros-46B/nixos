{ pkgs, ... }:

{
	powerManagement = {
		powertop.enable = true;
		cpuFreqGovernor = "powersave";
	};

	services.tlp = {
		enable = true;
		settings = {
			CPU_SCALING_GOVERNOR_ON_AC = "performance";
			CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
	
			CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
			CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

			CPU_BOOST_ON_AC = 1;
			CPU_BOOST_ON_BAT = 0;
			CPU_HWP_DYN_BOOST_ON_AC = 1;
			CPU_HWP_DYN_BOOST_ON_BAT = 0;
	
			CPU_MIN_PERF_ON_AC = 0;
			CPU_MAX_PERF_ON_AC = 100;
			CPU_MIN_PERF_ON_BAT = 0;
			CPU_MAX_PERF_ON_BAT = 75;
	
			START_CHARGE_THRESH_BAT0 = 70;
			STOP_CHARGE_THRESH_BAT0 = 80;
			RESTORE_THRESHOLDS_ON_BAT = 1;

			DEVICES_TO_DISABLE_ON_STARTUP = "bluetooth";
		};
	};
	services.upower.enable = true;
	services.thermald.enable = true;
	services.thinkfan.enable = true;

	# utils
	environment.systemPackages = with pkgs; [ acpi powertop ];

	# disable integrated camera
	boot.blacklistedKernelModules = [ "uvcvideo" ];

	# sound and wireless power saving
	boot.extraModprobeConfig = ''
		options snd_hda_intel power_save=1
		options iwlwifi power_save=1
		options iwlwifi uapsd_disable=0
		options iwlmvm power_scheme=3
	'';

	# aggregated disk writeback every minute instead of every 5 seconds
	boot.kernel.sysctl = {
		"vm.dirty_writeback_centisecs" = 6000;
		"vm.swappiness" = 10;
	};
	fileSystems."/".options = [ "commit=60" ];

	boot.initrd.availableKernelModules = [ "thinkpad_acpi" ];
}
