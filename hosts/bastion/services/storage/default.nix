{ inputs, ... }:

{
	imports = [
		./cgit.nix
		./copyparty.nix
		./shimmie.nix
		./syncthing.nix

		inputs.sidechain.nixosModules.default
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
		"/nas/music".d = {
			user = "root";
			group = "nas";
			mode = "0770";
		};
		"/nas/music_mirror".d = {
			user = "root";
			group = "nas";
			mode = "0770";
		};
	};

	services.sidechain = {
		enable = true;
		group = "nas";
		sourceDir = "/nas/music";
		destinationDir = "/nas/music_mirror";
		ignoredExtensions = [ "txt" "md" "zip" ];
		bitrate = 192;
		nice = 10;
	};
}
