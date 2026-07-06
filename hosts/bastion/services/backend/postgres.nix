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

	services.postgresql = {
		ensureDatabases = [ "shimmie" ];
		ensureUsers = [
			{
				name = "shimmie";
				ensureDBOwnership = true;
			}
		];
		# first one temporary for debugging
		authentication = ''
			local  all      all                    peer
			local  shimmie  shimmie                trust
			host   shimmie  shimmie  127.0.0.1/32  trust
			host   shimmie  shimmie  ::1/128       trust
		'';
	};
}
