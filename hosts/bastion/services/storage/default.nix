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

	# dirs not listed here are owned by specific service modules
	systemd.tmpfiles.settings."10-nas" = {
		"/mnt/nas".d = {
			user = "root";
			group = "nas";
			mode = "0750";
		};
		"/mnt/nas/inbox".d = {
			user = "copyparty";
			group = "copyparty";
			mode = "0750";
		};
		"/mnt/nas/public".d = {
			user = "copyparty";
			group = "copyparty";
			mode = "0750";
		};
		"/mnt/nas/private".d = {
			user = "copyparty";
			group = "copyparty";
			mode = "0750";
		};
		"/mnt/nas/media".d = { # TODO: suwayomi needs write
			user = "copyparty";
			group = "copyparty";
			mode = "0750";
		};
		"/mnt/nas/music".d = {
			user = "syncthing";
			group = "nas";
			mode = "2750";
		};
	};
}
