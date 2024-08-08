{ lib, pkgs, globals, functions, ... }:

let
	awesome = pkgs.awesome-git;
	path = lib.makeBinPath (with pkgs; [ awesome coreutils dbus libnotify ]);

	# {{{ make suspend/resume signalling service for awesomewm service
	mkAwesomeSignalService = signal: opts: lib.recursiveUpdate {
		# must be a system service because user services cannot use sleep.target
		description = "Signal ${signal} to AwesomeWM session";
		wantedBy = [ "multi-user.target" "suspend.target" ];
		# before/after = [ "suspend.target" ];

		serviceConfig = {
			User = globals.user;
			Type = "oneshot";
			Environment = "PATH='${path}' DISPLAY=':0' DBUS_SESSION_BUS_ADDRESS='unix:path=/run/user/1000/bus'";
			PassEnvironment = "PATH DISPLAY";

			# for after: ExecStartPre = "${pkgs.coreutils}/bin/sleep 2";
			ExecStart = ''
				${awesome}/bin/awesome-client "awesome.emit_signal('system::${signal}')"
			'';
		};
	} opts;
	signalSuspend = mkAwesomeSignalService "suspend" {
		before = [ "suspend.target" ];
	};
	signalResume = mkAwesomeSignalService "resume" {
		after = [ "suspend.target" ];
		serviceConfig.ExecStartPre = "${pkgs.coreutils}/bin/sleep 1";
	};
	# }}}
in
	functions.linkDots "awesome"
{
	services.xserver.displayManager.startx.enable = true;

	# install packages
	my.home.packages = with pkgs; [
		rofi
		picom
		libnotify
		i3lock-color
	];

	# home-manager xsession allows home-manager user services to work
	my.xsession = {
		enable = true;
		windowManager.awesome = {
			enable = true;
			package = awesome;
		};
	};

	xdg.portal = {
		enable = true;
		extraPortals = with pkgs; [
			xdg-desktop-portal-gtk
			xdg-desktop-portal-gnome # for gnome-network-displays
		];
	};

	# {{{ startx
	# initialize dbus, then call home-manager's xsession file
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
	# }}}

	# systemd.services.awesome-signal-suspend = signalSuspend;
	# systemd.services.awesome-signal-resume = signalResume;
}
