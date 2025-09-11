# Thinkpad p15v gen 2
{ lib, ... }:

{
	imports = [
		./services
		./system
	];

	hardware.enableRedistributableFirmware = true;
	hardware.cpu.intel.updateMicrocode = lib.mkDefault true;
}
