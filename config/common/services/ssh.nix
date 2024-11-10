{ globals, ... }:

{
	services.openssh = {
		enable = true;
		allowSFTP = true;
		settings = {
			AllowUsers = [ globals.user ];
			PermitRootLogin = "no";
			PasswordAuthentication = false;
			X11Forwarding = true;
		};
	};

	# TODO: send login info to discord webhook on a pam hook
}
