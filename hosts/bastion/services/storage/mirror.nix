{ inputs, ... }:

{
	imports = [
		inputs.sidechain.nixosModules.default
	];

	systemd.tmpfiles.settings."10-nas-mirror" = {
		"/nas/mirror".d = {
			user = "root";
			group = "nas";
			mode = "0770";
		};
		"/nas/mirror/music".d = {
			user = "root";
			group = "nas";
			mode = "0770";
		};
	};

	services.sidechain = {
		enable = true;
		group = "nas";
		sourceDir = "/nas/music";
		destinationDir = "/nas/mirror/music";
		ignoredExtensions = [ "txt" "md" "zip" ];
		ignoreDotfiles = true;
		bitrate = 192;
		nice = 10;
	};
}
