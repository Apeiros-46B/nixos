{ config, ... }:

{
	hardware.bluetooth = {
		enable = true;
		powerOnBoot = false;
	};

	services.blueman.enable = true;

	# rfkill bluetooth on start
	services.udev.extraRules = ''
		SUBSYSTEM=="rfkill", ATTR{type}=="bluetooth", ATTR{state}="0"
	'';
}
