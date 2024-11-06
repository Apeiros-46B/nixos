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

	users.users.${globals.user}.openssh.authorizedKeys.keys = [
		"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDJZmaaN5kFV74MHGGroN+hRqxMzmypm7iKz3njTkMCj apeiros@atlas"
	];
}
