{ pkgs, config, globals, ... }:

{
	hm.home.packages = with pkgs; [
		wl-clipboard
	];

	programs.ydotool.enable = true;
	users.users.${globals.user}.extraGroups = [ config.programs.ydotool.group ];

	# use a GTK agent (easier to theme) instead of the one provided by niri-flake
	systemd.user.services.niri-flake-polkit.enable = false;
	hm.systemd.user.services.polkit-gnome-authentication-agent-1 = {
		Unit = {
			Description = "GNOME Polkit authentication agent";
			Wants = [ "graphical-session.target" ];
			After = [ "graphical-session.target" ];
		};
		Service = {
			Type = "simple";
			ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
			Restart = "on-failure";
			RestartSec = 1;
			TimeoutStopSec = 10;
		};
		Install = {
			WantedBy = [ "graphical-session.target" ];
		};
	};
}
