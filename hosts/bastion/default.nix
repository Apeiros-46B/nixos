# this is not technically a bastion host but who cares it sounds cool
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
		"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILrKvFTiJMDrjf0Fi6gm5JgNBqv/Y80ckn7wbciEzXJm apeiros@g16"
	];

	hardware.enableRedistributableFirmware = true;
	hardware.cpu.intel.updateMicrocode = lib.mkDefault true;
}
