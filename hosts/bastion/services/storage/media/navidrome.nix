{ pkgs, config, inputs, globals, ... }:

let
	port = 4533;
	domain = "mus.${globals.net.pubDomain}";
	losslessDir = "/mnt/media/music";
	lossyDir = "/var/lib/navidrome-mirror";
in {
	imports = [
		inputs.sidechain.nixosModules.default
	];

	services.syncthing.settings.folders.music = {
		id = "53ln6-dw9cy";
		path = losslessDir;
		type = "receiveonly";
		devices = [
			"acropolis"
			"atlas"
		];
		ignorePatterns = [ ".hist" ]; # copyparty files
		ignorePerms = true;
	};

	systemd.tmpfiles.settings."10-nas-navidrome".${lossyDir}.d = {
		user = "sidechain";
		group = "navidrome";
		mode = "2750";
	};

	# mirror flacs to 192k opus
	services.sidechain = {
		enable = true;
		sourceDir = losslessDir;
		destinationDir = lossyDir;
		ignoredExtensions = [ "txt" "md" "zip" ];
		ignoreDotfiles = true;
		copy = true;
		bitrate = 192;
		nice = 10;
	};
	systemd.services.sidechain.serviceConfig.UMask = "0027";

	my.services.rproxy.domains.${domain} = port;

	sops.secrets.navidrome-env = {
		sopsFile = ./Secrets.yaml;
		owner = "navidrome";
		group = "navidrome";
		mode = "0400";
	};

	services.navidrome = {
		enable = true;
		openFirewall = true;
		environmentFile = config.sops.secrets.navidrome-env.path;
		settings = {
			Port = port;
			Address = "0.0.0.0";
			BaseUrl = "https://${domain}";
			ShareURL = "https://${domain}";
			Agents = "";
			MusicFolder = lossyDir;
			EnableArtworkUpload = false;
			EnableExternalServices = false;
			EnableUserRegistration = false;
			EnableUserEditing = false;
			FFmpegPath = "${pkgs.ffmpeg}/bin/ffmpeg";
			Scanner.ArtistJoiner = ", ";
			Subsonic.ArtistParticipations = true;
		};
	};
}
