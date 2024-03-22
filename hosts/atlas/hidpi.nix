{ config, lib, pkgs, globals, ... }:

{
	services.xserver = {
		# TODO: is this the correct value for a 2x scale from 1080p?
		dpi = lib.mkForce 192;
		libinput = {
			mouse.accelSpeed = "1.0";
			touchpad.accelSpeed = "1.0";
		};
	};

	my.home.pointerCursor.size = lib.mkForce 128;

	environment.variables = {
		GDK_SCALE = "2";
		GDK_DPI_SCALE = "0.5";
		_JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
	};

	boot.loader.systemd-boot.consoleMode = "1";

	# override river dpi settings
	my.xdg.configFile."river/scale".text = lib.mkForce ''
		scale=2
		${pkgs.wlr-randr}/bin/wlr-randr --output eDP 1 --scale "$scale"
	'';
}
