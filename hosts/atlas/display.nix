{ pkgs, ... }:

{
	environment.systemPackages = [ pkgs.brightnessctl ];

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
				width = 1920;
				height = 1080;
			};
			scale = 1;
		};
	};

	# make text readable in bootloader
	boot.loader.systemd-boot.consoleMode = "1";
}
