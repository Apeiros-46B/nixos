{ ... }:

{
	services.openssh = {
		enable = true;
		allowSFTP = true;
		settings = {
			PermitRootLogin = "no";
			# TODO: figure out why accessing github via ssh keypair does not work (prompts for password, enter correct password, prompts again without message)
			PasswordAuthentication = false;
			X11Forwarding = true;
		};
	};
}
