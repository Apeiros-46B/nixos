{ pkgs, ... }:

{
	services.xserver = {
		enable = true;
		dpi = 128;
		exportConfiguration = true;
	};

	hm.home.packages = with pkgs; [
		xclip
		libnotify
	];

	hm.xsession.profileExtra = ''
		${pkgs.xset}/bin/xset r rate 350 75
	'';
}
