{ pkgs, ... }:

{
	services.xserver = {
		enable = true;

		dpi = 96;

		libinput = {
			enable = true;
			mouse = {
				accelSpeed = "0.8";
				accelProfile = "flat";
			};
			touchpad = {
				accelSpeed = "0.8";
				accelProfile = "flat";
				tappingDragLock = false;
				tappingButtonMap = "lrm";
				clickMethod = "clickfinger";
			};
		};

		exportConfiguration = true;
	};

	my.xsession.profileExtra = ''
		${pkgs.xorg.xset}/bin/xset r rate 350 75
	'';
}
