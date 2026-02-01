{ pkgs, config, globals, ... }:

{
	hm.home.packages = with pkgs; [
		xwayland-satellite
		wl-clipboard
	];

	programs.ydotool.enable = true;
	users.users.${globals.user}.extraGroups = [ config.programs.ydotool.group ];

	# use a GTK agent (easier to theme) instead of the one provided by niri-flake
	systemd.user.services.niri-flake-polkit.enable = false;
	systemd.user.services.polkit-gnome-authentication-agent-1 = {
		description = "GNOME Polkit authentication agent";
		wantedBy = [ "graphical-session.target" ];
		wants = [ "graphical-session.target" ];
		after = [ "graphical-session.target" ];
		serviceConfig = {
			Type = "simple";
			ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
			Restart = "on-failure";
			RestartSec = 1;
			TimeoutStopSec = 10;
		};
	};
}
