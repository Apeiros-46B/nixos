{ pkgs, ... }:

{
	programs.seahorse.enable = true;
	programs.gnupg.agent.enable = true;
	services.gnome.gnome-keyring.enable = true;

	environment.systemPackages = [ pkgs.libsecret ];

	hm.home.sessionVariables.SSH_AUTH_SOCK = "\${XDG_RUNTIME_DIR}/keyring/ssh";
	systemd.user.services.gnome-keyring-daemon = {
		partOf = [ "graphical-session-pre.target" ];
		wantedBy = [ "graphical-session-pre.target" ];
		description = "GNOME Keyring Daemon";
		serviceConfig = {
			ExecStart = "/run/wrappers/bin/gnome-keyring-daemon --start --foreground";
			Restart = "on-abort";
		};
	};

	# hm.xsession.profileExtra = ''
	# 	eval $(${pkgs.gnome-keyring}/bin/gnome-keyring-daemon \
	# 			 --daemonize \
	# 			 --components=ssh,secrets)
	# 	export SSH_AUTH_SOCK
	# '';
}
