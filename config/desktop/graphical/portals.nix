{ pkgs, ... }:

{
	xdg.portal = {
		enable = true;
		extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
		config = {
			niri.default = [ "gtk" ];
			awesome.default = [ "gtk" ];
			common.default = [ "gtk" ];
		};
	};
}
