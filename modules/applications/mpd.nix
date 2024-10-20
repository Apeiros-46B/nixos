{ pkgs, config, globals, ... }:

let
	mpdAddress = "127.0.0.1";
	mpdPort = 6600;
	mpdDataDir = "${globals.dir.mus}/mpd";

	visName = "ncmpcpp visualizer feed";
	visPath = "${mpdDataDir}/visualizer.fifo";
	visStereo = true;
in {
	my.services.mpd = {
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

	my.services.mpd-mpris = {
		enable = true;
		mpd.useLocal = true;
	};

	my.services.mpd-discord-rpc = {
		enable = true;
		settings = {
			hosts = [ "${mpdAddress}:${toString mpdPort}" ];
			format = {
				details = "$title";
				state = "on \"$album\" by $artist";
			};
		};
	};

	services.mpdscribble = {
		enable = true;
		host = mpdAddress;
		port = mpdPort;
		endpoints = {
			"last.fm" = {
				username = "Apeiros-46B";
				passwordFile = "${globals.home}/auth/.lfm.pw"; # TODO use sops-nix
			};
		};
	};

	my.home.packages = [ pkgs.mpc-cli ];

	my.programs.ncmpcpp = {
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
			visualizer_type = "spectrum";
			visualizer_look = "●▮";

			# TODO: this doesn't work
			execute_on_song_change = "${pkgs.writeShellScriptBin "songinfo" ''
				mpc='${pkgs.mpc-cli}/bin/mpc'
				ffmpeg='${pkgs.ffmpeg}/bin/ffmpeg'

				previewdir='${globals.dir.cfg}/ncmpcpp/previews/'
				fname="$($mpc --format '${globals.dir.mus}/%file%' current)"}
				preview="$previewdir/$($mpc --format '%album%' current | base64).png"

				[ -e "$preview" ] || $ffmpeg -y -i "$fname" -an -vf scale=128:128 "$preview" > /dev/null 2>&1

				notify-send \
					-i "$previewname" \
					"$($mpc --format '%artist% - %title%' current)" \
					"$($mpc --format 'on %album% [mpd]' current)"
			''}/bin/songinfo";
		};
		# bindings = {}; # TODO
	};

	my.programs.beets = {
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

			plugins = [ "play" "playlist" ];

			play = {
				relative_to = globals.dir.mus;
				command = "${pkgs.mpc-cli}/bin/mpc add";
			};

			playlist = {
				auto = "yes";
				relative_to = globals.dir.mus;
				playlist_dir = config.my.services.mpd.playlistDirectory;
			};
		};
	};
}
