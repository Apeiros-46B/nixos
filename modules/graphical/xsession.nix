{ pkgs, globals, functions, ... }:

functions.linkDots "awesome" {
	# X session software
	services.xserver = {
		windowManager.awesome = {
			enable = true;
			package = pkgs.awesome-git; # overlayed
		};
	};
	my.home.packages = with pkgs; [
		rofi
		picom
		libnotify
		i3lock-color
	];

	# startx scripts
	my.xsession.enable = true;
	services.xserver.displayManager.startx.enable = true;

	my.home.file.".xinitrc".text = ''
		if test -z "$DBUS_SESSION_BUS_ADDRESS"; then
			eval $(dbus-launch --exit-with-session --sh-syntax)
		fi

		systemctl --user import-environment DISPLAY XAUTHORITY

		if command -v dbus-update-activation-environment >/dev/null 2>&1; then
			dbus-update-activation-environment DISPLAY XAUTHORITY
		fi

		bash "${globals.home}/.xsession" '${pkgs.awesome-git}/bin/awesome'
	'';
}
