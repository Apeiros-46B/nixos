{ pkgs, ... }:

{
	services.xserver = {
		enable = true;
		dpi = 96;
		exportConfiguration = true;

		# digimend.enable = true; # TODO: reenable this when i have enough time for a kernel recompilation on all machines
	};

	services.libinput = {
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

	hm.xsession.profileExtra = ''
		${pkgs.xorg.xset}/bin/xset r rate 350 75
	'';

	hm.home.pointerCursor = {
		name = "phinger-cursors-light";
		package = pkgs.phinger-cursors;
		size = 24;
		gtk.enable = true;
		x11 = {
			enable = true;
			defaultCursor = "left_ptr";
		};
	};
}
