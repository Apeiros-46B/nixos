{ pkgs, config, inputs, globals, ... }:

let
	port = 4533;
	domain = "mus.${globals.net.pubDomain}";
	musicDir = "/var/lib/navidrome-mirror";
in {
	imports = [
		inputs.sidechain.nixosModules.default
	];

	systemd.tmpfiles.settings."10-nas-navidrome".${musicDir}.d = {
		user = "sidechain";
		group = "navidrome";
		mode = "2750";
	};

	# mirror flacs to 192k opus
	services.sidechain = {
		enable = true;
		sourceDir = "/nas/music";
		destinationDir = musicDir;
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
			MusicFolder = musicDir;
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
