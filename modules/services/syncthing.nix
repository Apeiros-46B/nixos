{ config, globals, ... }:

{
	services.syncthing = {
		enable = true;
		user = globals.user;
		dataDir = "${globals.dir.pub}";
		configDir = "${globals.dir.cfg}/syncthing";
	};
}
