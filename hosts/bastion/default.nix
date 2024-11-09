{ lib, globals, ... }:

{
	imports = [
		./services
		./system
	];

	users.users.${globals.user}.openssh.authorizedKeys.keys = [
		"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDJZmaaN5kFV74MHGGroN+hRqxMzmypm7iKz3njTkMCj apeiros@atlas"
		"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIExBf32YE7rTYSTwpdKYSFldb0FN4pv5XEl4ec62PtPE apeiros@infinitum"
	];

	hardware.enableRedistributableFirmware = true;
	hardware.cpu.intel.updateMicrocode = lib.mkDefault true;
}
