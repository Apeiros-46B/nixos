{ config, globals, ... }:

{
	users.users.${globals.user} = {
		uid = globals.uid;
		isNormalUser = true;
		extraGroups = [
			"networkmanager" # allow configuring networks through NM
			"wheel"          # allow sudo
		];
	};

	hm.xdg = {
		configHome = "${globals.home}/.config";
		userDirs = {
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
	};

	# hacky
	environment.variables = {
		XDG_CONFIG_HOME = config.hm.xdg.configHome;
	};
}
