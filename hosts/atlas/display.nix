{ pkgs, ... }:

{
	environment.systemPackages = [ pkgs.brightnessctl ];

	hm.home.packages = let xrandr = "${pkgs.xorg.xrandr}/bin/xrandr"; in [
		(pkgs.writeShellScriptBin "screenlayout" ''
			# the default resize filter on this machine is actually ok (cmp. to bilinear)
			alias SET="${xrandr} --output eDP-1 --mode 1920x1080 --scale 1 --output HDMI-1"
			[ "$1" ] || exit 1
			[ "$1" == default ] && SET off || SET "--$1" eDP-1
		'')
	];

	hm.xsession.profileExtra = "screenlayout default";

	# make text readable in bootloader
	boot.loader.systemd-boot.consoleMode = "1";
}
