{ globals, ... }:

{
	hm.xdg = {
		configHome = globals.dir.cfg;
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

	environment.variables.XDG_CONFIG_HOME = globals.dir.cfg;
}
