{ ... }:

let
	dataDir = "/srv/psql";
in {
	systemd.tmpfiles.settings."10-psql".${dataDir}.d = {
		user  = "postgresql";
		group = "postgresql";
		mode  = "0770";
	};
	services.postgresql = {
		enable = true;
		enableTCPIP = true;
		settings.port = 5432;
	};
}
