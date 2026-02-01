{ pkgs, ... }:

{
	xdg.portal = {
		enable = true;
		extraPortals = with pkgs; [
			xdg-desktop-portal-gtk
			xdg-desktop-portal-gnome
		];
		config = {
			# prioritize gnome (for screenshare)
      niri.default = [ "gnome" "gtk" ];
      awesome.default = [ "gtk" ];
      common.default = [ "gtk" ];
    };
	};
}
