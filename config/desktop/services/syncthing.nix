{ globals, ... }:

{
	# already enabled in common/services/syncthing, just set some PC-specific options
	services.syncthing = {
		user = globals.user;
		dataDir = "${globals.dir.pub}";
		configDir = "${globals.dir.cfg}/syncthing";
	};
}
