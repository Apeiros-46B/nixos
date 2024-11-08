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
}
