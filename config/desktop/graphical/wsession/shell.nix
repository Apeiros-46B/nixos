{ pkgs, functions, theme, ... }:

functions.linkImpure "quickshell" {
	hm.home.packages = with pkgs; [
		swaylock
		swww
	];

	environment.systemPackages = [ pkgs.quickshell ];
	hm.systemd.user.services.quickshell = {
		Unit = {
			Description = "Quickshell";
			PartOf = [ "graphical-session.target" ];
			After = [ "graphical-session.target" ];
			ConditionEnvironment = "WAYLAND_DISPLAY";
		};
		Service = {
			ExecStart = "${pkgs.quickshell}/bin/quickshell";
			Restart = "on-failure";
			RestartSec = 1;
		};
		Install.WantedBy = [ "graphical-session.target" ];
	};

	hm.services.swww.enable = true;

	hm.services.mako = {
		enable = true;
		settings = with theme.colorsHash; {
			default-timeout = 5000;
			border-size = 0;
			border-radius = 0;
			padding = "16";
			margin = "24";
			max-icon-size = 48;
			width = 400;
			text-color = fg0;
			progress-color = green;
			background-color = bg1;
		};
	};
}
