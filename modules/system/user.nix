{ config, pkgs, globals, ... }:

{
	users.users.${globals.user} = {
		isNormalUser = true;
		extraGroups = [
			"networkmanager" # allow configuring networks through NM
			"video"          # allow brightnessctl
			"wheel"          # allow sudo
		];
	};

	home-manager.users.${globals.user}.xdg.userDirs = {
		enable = true;
		createDirectories = false;

		desktop     = globals.dir.desk;
		documents   = globals.dir.doc;
		download    = globals.dir.dl;
		music       = globals.dir.mus;
		pictures    = globals.dir.pic;
		publicShare = globals.dir.pub;
		templates   = globals.dir.tmpl;
		videos      = globals.dir.vid;
	};
}
