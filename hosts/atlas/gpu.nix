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
			package = config.boot.kernelPackages.nvidiaPackages.production;
			open = false;

			# this doesn't work; nvidia-powerd fails with
			# "Error finding power policy"
			# "Failed to initialize RM client"
			# dynamicBoost.enable = true;

			modesetting.enable = true;
			nvidiaSettings = true;

			# might cause suspend panic, idk
			powerManagement.enable = true;
			powerManagement.finegrained = true;

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
