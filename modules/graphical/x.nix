{ pkgs, ... }:

{
	services.xserver = {
		enable = true;
		dpi = 96;
		exportConfiguration = true;

		libinput = {
			enable = true;
			mouse = {
				accelSpeed = "0.0";
				accelProfile = "flat";
				middleEmulation = false;
			};
			touchpad = {
				accelSpeed = "0.8";
				accelProfile = "flat";
				middleEmulation = false;
				tappingDragLock = false;
				tappingButtonMap = "lrm";
				clickMethod = "clickfinger";
			};
		};
	};

	hm.xsession.profileExtra = ''
		${pkgs.xorg.xset}/bin/xset r rate 350 75
	'';
}
