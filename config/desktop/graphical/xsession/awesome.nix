{ pkgs, functions, ... }:

let
	awesomeOpts = {
		enable = true;
		package = pkgs.awesome-git;
	};
in functions.linkImpure "awesome" {
	hm.home.packages = with pkgs; [
		picom
		i3lock-color
	];

	services.xserver.windowManager.awesome = awesomeOpts;

	# this one starts home-manager user services
	hm.xsession = {
		enable = true;
		windowManager.awesome = awesomeOpts;
	};
}
