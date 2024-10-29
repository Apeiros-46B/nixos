{ pkgs, config, globals, ... }:

let
	lfmUser = "Apeiros-46B";

	mpdAddress = "127.0.0.1";
	mpdPort = 6600;
	mpdDataDir = "${globals.dir.mus}/.mpd";

	visName = "ncmpcpp visualizer feed";
	visPath = "${mpdDataDir}/visualizer.fifo";
	visStereo = true;
in {
	hm.home.packages = with pkgs; [
		mpc-cli
		yt-dlp

		ffmpeg
		chromaprint

		python312Packages.pyacoustid
		python312Packages.requests
		python312Packages.beautifulsoup4
		python312Packages.pylast
	];

	hm.services.mpd = {
		enable = true;
		network = {
			startWhenNeeded = false;
			listenAddress = mpdAddress;
			port = mpdPort;
		};

		dataDir = mpdDataDir;
		musicDirectory = globals.dir.mus;

		extraConfig = ''
			audio_output {
				type "pipewire"
				name "PipeWire output"
			}

			audio_output {
				type   "fifo"
				name   "${visName}"
				path   "${visPath}"
				format "44100:16:${if visStereo then "2" else "1"}"
			}
		'';
	};

	hm.services.mpd-mpris = {
		enable = true;
		mpd.useLocal = true;
	};

	hm.services.mpd-discord-rpc = {
		enable = true;
		settings = {
			hosts = [ "${mpdAddress}:${toString mpdPort}" ];
			format = {
				details = "$title [$duration]";
				state = "$artist / $album";
				small_image = "";
			};
		};
	};

	services.mpdscribble = {
		enable = true;
		host = mpdAddress;
		port = mpdPort;
		endpoints = {
			"last.fm" = {
				username = lfmUser;
				passwordFile = "${globals.home}/auth/.lfm.pw"; # TODO use sops-nix
			};
		};
	};

	hm.programs.ncmpcpp = {
		enable = true;
		package = pkgs.ncmpcpp.override {
			visualizerSupport = true;
		};

		settings = {
			mpd_host = mpdAddress;
			mpd_port = mpdPort;
			lyrics_directory = "${mpdDataDir}/lyrics";

			visualizer_output_name = visName;
			visualizer_data_source = visPath;
			visualizer_in_stereo = if visStereo then "yes" else "no";
			visualizer_type = "wave_filled";
			visualizer_look = "●█";

			# TODO: move this into a separate service (a shell script) separate from ncmpcpp
			execute_on_song_change = "${pkgs.writeShellScriptBin "ncmpcpp-notify-songinfo" ''
				mpc='${pkgs.mpc-cli}/bin/mpc'
				notify='${pkgs.libnotify}/bin/notify-send'

				# find first image
				album_dir="${globals.dir.mus}/$(dirname "$($mpc -f '%file%' current)")"
				cover="$(find "$album_dir" -type f | awk '/jpg|png|webp$/ { print $0; exit }')"

				$notify \
					-i "$cover" \
					"$($mpc -f '%artist% - %title%' current)" \
					"$($mpc -f 'on %album% [mpd]' current)"
			''}/bin/ncmpcpp-notify-songinfo";
		};
		# bindings = {}; # TODO
	};

	hm.programs.beets = {
		enable = true;
		mpdIntegration = {
			enableStats = false;
			enableUpdate = true;
			host = mpdAddress;
			port = mpdPort;
		};
		settings = {
			directory = globals.dir.mus;
			mpd.music_directory = globals.dir.mus;

			paths = {
				default   = "$albumartist/$atypes$album%aunique{}/$track.$title";
				comp      = "Various Artists/$atypes$album%aunique{}/$track.$title";
				singleton = "$artist/_Singleton%aunique{}/$title";
			};

			plugins = [
				"play"
				"playlist"

				# metadata
				"fromfilename"
				"albumtypes"
				"lastimport"
				"lastgenre"
				"fetchart"
				"lyrics"
				"edit"

				# audio analysis
				"bpm"
				# "chroma" # need to install dependencies first
				"replaygain"

				# searching
				"fuzzy"
				"types"
				"missing"
			];

			play = {
				relative_to = globals.dir.mus;
				command = "bash -c 'cat $0 | ${pkgs.mpc-cli}/bin/mpc add'";
			};
			playlist = {
				auto = "yes";
				relative_to = globals.dir.mus;
				playlist_dir = config.hm.services.mpd.playlistDirectory;
			};

			albumtypes = {
        ep          = "EP";
        single      = "Single";
        soundtrack  = "OST";
        live        = "Live";
        compilation = "Compilation";
        remix       = "Remix";
			};
			lastfm.user = lfmUser;
			lastgenre = {
				force = "no";
				min_weight = 2;
				title_case = "no";
			};

			bpm.max_strokes = 10;
			replaygain = {
				backend = "ffmpeg";
			};

			types.rating = "int";
		};
	};
}
