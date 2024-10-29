{ pkgs, ... }:

{
	programs.gnupg.agent = {
		enable = true;
		enableSSHSupport = true;
		pinentryPackage = pkgs.pinentry-curses;
	};

	# apparently not needed for network connectivity
	services.gnome.gnome-keyring.enable = true;
	hm.xsession.profileExtra = ''
		eval $(${pkgs.gnome.gnome-keyring}/bin/gnome-keyring-daemon \
				 --daemonize \
				 --components=ssh,secrets)
		export SSH_AUTH_SOCK
	'';

	programs.seahorse.enable = true;

	environment.systemPackages = [ pkgs.gcr ];
}
