{ lib, globals, ... }:

{
	imports = [
		./services
		./system
	];

	users.users.${globals.user}.openssh.authorizedKeys.keys = [
		"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDJZmaaN5kFV74MHGGroN+hRqxMzmypm7iKz3njTkMCj apeiros@atlas"
		"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINgFgJiX9CsXqJUJ9p7jVVleKYaOIOTHkppjbuIR9pMf apeiros@acropolis"
		"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL4v3e2QzbE7YIzRT1+jmldGlo1Lh94dl0DvlgCYLZfv apeiros@parthenon"
	];

	hardware.enableRedistributableFirmware = true;
	hardware.cpu.intel.updateMicrocode = lib.mkDefault true;
}
