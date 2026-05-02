{ inputs, ... }:

{
	imports = [
		./copyparty.nix
		./navidrome.nix
		./radicle.nix
		./shimmie.nix
		./syncthing.nix
	];

	systemd.tmpfiles.settings."10-nas" = {
		"/nas".d = {
			user = "root";
			group = "nas";
			mode = "2770"; # SGID bit for syncthing
		};
		"/nas/inbox".d = {
			user = "root";
			group = "nas";
			mode = "0770";
		};
		"/nas/public".d = {
			user = "root";
			group = "nas";
			mode = "0770";
		};
		"/nas/private".d = {
			user = "root";
			group = "nas";
			mode = "0770";
		};
		"/nas/music".d = {
			user = "root";
			group = "nas";
			mode = "0770";
		};
		"/nas/joplin".d = {
			user = "root";
			group = "nas";
			mode = "0770";
		};
	};
}
