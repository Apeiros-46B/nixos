{ config, pkgs, ... }:

{
	services.xserver = {
		enable = true;

		libinput = {
			enable = true;
			mouse = {
				accelProfile = "flat";
			};
			touchpad = {
				accelProfile = "flat";
				tappingDragLock = false;
				tappingButtonMap = "lrm";
				clickMethod = "clickfinger";
			};
		};
	};

	my.xsession.profileExtra = ''
		${pkgs.xorg.xset}/bin/xset r rate 350 75
	'';
}
