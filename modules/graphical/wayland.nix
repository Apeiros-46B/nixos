{ pkgs, ... }:

{
	environment.sessionVariables.NIXOS_OZONE_WL = "1";

	hm.home.pointerCursor = {
		name = "phinger-cursors-light";
		package = pkgs.phinger-cursors;
		size = 32;
		gtk.enable = true;
		x11 = {
			enable = true;
			defaultCursor = "left_ptr";
		};
	};

	# real-time priority
	security.pam.loginLimits = [
		{
			domain = "@users";
			item = "rtprio";
			type = "-";
			value = 1;
		}
	];
}
