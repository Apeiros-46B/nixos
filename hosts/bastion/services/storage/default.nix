{ ... }:

{
	imports = [
		./cgit.nix
		./copyparty.nix
		./shimmie.nix
		./syncthing.nix
	];

	systemd.tmpfiles.settings."10-nas" = {
		"/nas".d = {
			user = "root";
			group = "nas";
			mode = "0770";
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
	};
}
