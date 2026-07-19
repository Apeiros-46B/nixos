{ ... }:

{
	# TODO: samba at toplevel
	# TODO: copyparty at toplevel (separate volumes per thing)
	imports = [
		./copyparty.nix
		./syncthing.nix
		./nas
		./media
	];

	# restic can see everything, no need to add it here
	users.groups = {
		nas.members = [
			# TODO: move shimmie, sidechain and navidrome to media
			"root"
			"copyparty"
			"immich"
			"shimmie"
		];
		media.members = [
			# TODO: slskd, suwayomi, kavita, jellyfin
			"root"
			"copyparty"
			"syncthing"
			"sidechain"
			"navidrome"
		];
		copyparty.members = [ "immich" ]; # external libraries
		syncthing.members = [ "copyparty" "sidechain" ];
	};

	# dirs not listed here are owned by specific service modules
	systemd.tmpfiles.settings."10-storage" = {
		"/mnt/media".d = {
			user = "root";
			group = "media";
			mode = "0750";
		};
		"/mnt/media/music".d = {
			user = "syncthing";
			group = "media";
			mode = "2750";
		};

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
	};
}
