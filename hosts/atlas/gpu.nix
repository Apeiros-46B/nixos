{ config, pkgs, ... }:

{
	services.xserver.videoDrivers = [ "nvidia" ];
	# boot.initrd.kernelModules = [ "nvidia" ];
	# boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];

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
			package = config.boot.kernelPackages.nvidiaPackages.stable;
			open = false;

			# this doesn't work; nvidia-powerd fails with
			# "Error finding power policy"
			# "Failed to initialize RM client"
			# dynamicBoost.enable = true;

			modesetting.enable = true;
			nvidiaSettings = true;

			# might cause suspend panic, idk
			powerManagement.enable = false;
			powerManagement.finegrained = false;

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
