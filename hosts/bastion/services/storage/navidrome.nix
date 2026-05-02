{ pkgs, config, inputs, globals, ... }:

let
	port = 4533;
	domain = "mus.${globals.net.pubDomain}";
	musicDir = "/nas/navidrome";
in {
	imports = [
		inputs.sidechain.nixosModules.default
	];

	systemd.tmpfiles.settings."10-nas-navidrome" = {
		${musicDir}.d = {
			user = "root";
			group = "nas";
			mode = "0770";
		};
	};

	# mirror flacs to 192k opus
	services.sidechain = {
		enable = true;
		group = "nas";
		sourceDir = "/nas/music";
		destinationDir = musicDir;
		ignoredExtensions = [ "txt" "md" "zip" ];
		ignoreDotfiles = true;
		bitrate = 192;
		nice = 10;
	};

	my.services.rproxy.domains.${domain} = port;

	sops.secrets.navidrome-env = {
		sopsFile = ./Secrets.yaml;
		owner = "navidrome";
		group = "nas";
		mode = "0400";
	};

	services.navidrome = {
		enable = true;
		group = "nas";
		openFirewall = true;
		environmentFile = config.sops.secrets.navidrome-env.path;
		settings = {
			Port = port;
			Address = "0.0.0.0";
			BaseUrl = "https://${domain}";
			ShareURL = "https://${domain}";
			Agents = "deezer,listenbrainz";
			MusicFolder = musicDir;
			EnableArtworkUpload = false;
			EnableUserRegistration = false;
			EnableUserEditing = false;
			FFmpegPath = "${pkgs.ffmpeg}/bin/ffmpeg";
			LastFM.ScrobbleFirstArtistOnly = true;
			Scanner.ArtistJoiner = ", ";
			Subsonic.ArtistParticipations = true;
		};
	};
}
