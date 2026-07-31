{ pkgs, functions, ... }:

let
	awesomeOpts = {
		enable = true;
		package = pkgs.awesome-git;
	};
in functions.linkImpure "awesome" {
	hm.home.packages = with pkgs; [
		picom-git
		i3lock-color
	];

	services.xserver = {
		displayManager.startx.enable = true;
		windowManager.awesome = awesomeOpts;
	};

	# this one starts home-manager user services
	hm.xsession = {
		enable = true;
		windowManager.awesome = awesomeOpts;
	};

	hm.home.file.".xinitrc".text = ''
		source ~/.xsession
	'';
}
