{ pkgs, ... }:

{
	services.xserver = {
		enable = true;
		dpi = 96;
		exportConfiguration = true;
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
