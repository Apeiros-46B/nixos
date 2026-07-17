{ ... }:

{
	imports = [
		./copyparty.nix
		./immich.nix
		./navidrome.nix
		./shimmie.nix
		./syncthing.nix
	];

	# restic can see everything, no need to add it here
	users.groups = {
		nas.members = [
			"root"
			"copyparty"
			"immich"
			"navidrome"
			"sidechain"
			"shimmie"
			"syncthing"
		];
		copyparty.members = [ "immich" ]; # external libraries
		syncthing.members = [ "copyparty" "sidechain" ];
	};

	# other dirs owned by specific services
	systemd.tmpfiles.settings."10-nas" = {
		"/nas".d = {
			user = "root";
			group = "nas";
			mode = "0750";
		};
		"/nas/inbox".d = {
			user = "copyparty";
			group = "copyparty";
			mode = "0750";
		};
		"/nas/public".d = {
			user = "copyparty";
			group = "copyparty";
			mode = "0750";
		};
		"/nas/private".d = {
			user = "copyparty";
			group = "copyparty";
			mode = "0750";
		};
		"/nas/music".d = {
			user = "syncthing";
			group = "nas";
			mode = "2750";
		};
	};
}
