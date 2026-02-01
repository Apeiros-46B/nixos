{ pkgs, ... }:

{
	services.xserver = {
		enable = true;
		dpi = 96;
		exportConfiguration = true;
	};

	hm.home.packages = with pkgs; [
		xclip
		libnotify
	];

	hm.xsession.profileExtra = ''
		${pkgs.xorg.xset}/bin/xset r rate 350 75
	'';
}
