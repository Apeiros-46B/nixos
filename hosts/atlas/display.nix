{ ... }:

{
	hm.xsession.profileExtra = ''
		xrandr --output eDP-1 --scale 0.5x0.5 --filter nearest
	'';

	# make text readable in bootloader
	boot.loader.systemd-boot.consoleMode = "1";
}
