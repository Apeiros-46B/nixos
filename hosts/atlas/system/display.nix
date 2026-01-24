{ config, pkgs, globals, ... }:

{
	environment.systemPackages = with pkgs; [
		brightnessctl
		gammastep
	];

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

	hm.home.packages = let xrandr = "${pkgs.xorg.xrandr}/bin/xrandr"; in [
		(pkgs.writeShellScriptBin "screenlayout" ''
			function SET() {
				# the default resize filter on this machine is actually ok (cmp. to bilinear)
				${xrandr} --output eDP-1 --mode 1920x1080 --scale 1 --primary \
				          --output HDMI-1 "$@"
			}

			if [ -z "$1" ]; then
				exit 1
			elif [ "$1" == default ]; then
				SET --off
			elif [ "$1" == mirror ]; then
				SET --mode 1920x1080 --same-as eDP-1
			else
				SET --auto "--$1" eDP-1
			fi
		'')
	];

	hm.xsession.profileExtra = "screenlayout default";
	hm.programs.niri.settings.outputs = {
		eDP-1 = {
			position = {
				x = 0;
				y = 1080;
			};
			mode = {
				width = 3840;
				height = 2160;
			};
			scale = 2;
		};
		HDMI-A-1 = {
			position = {
				x = 0;
				y = 0;
			};
			mode = {
				width = 2560;
				height = 1440;
			};
			scale = 4.0 / 3.0;
		};
	};

	# make text readable in bootloader
	boot.loader.systemd-boot.consoleMode = "1";
}
