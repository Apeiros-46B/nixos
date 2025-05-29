{ config, pkgs, globals, ... }:

{
	services.xserver.videoDrivers = [ "nvidia" ];
	users.users.${globals.user}.extraGroups = [ "video" "render" ];

	hardware = {
		graphics = {
			enable = true;
			enable32Bit = true;
			extraPackages = with pkgs; [
				rocmPackages.clr.icd
				intel-compute-runtime
			];
		};

		nvidia = {
			# open modules only support power management after Ampere, which I don't have
			open = false;
			package = config.boot.kernelPackages.nvidiaPackages.production;
			nvidiaSettings = true;

			modesetting.enable = true;
			powerManagement = {
				enable = true;
				finegrained = true;
			};
			prime = {
				offload = {
					enable = true;
					enableOffloadCmd = true;
				};
				intelBusId = "PCI:0:2:0";
				nvidiaBusId = "PCI:1:0:0";
			};
		};
	};
}
