{ ... }:

{
	hm.xsession.profileExtra = ''
		# xrandr --output eDP-1 --scale 0.5x0.5 --filter nearest

		# the default resizing filter on this machine is actually ok (cmp. to bilinear)
		xrandr --output eDP-1 --mode 1920x1080
	'';

	# make text readable in bootloader
	boot.loader.systemd-boot.consoleMode = "1";
}
