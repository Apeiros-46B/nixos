{ config, pkgs, globals, ... }:

let
	lfmUser = "Apeiros-46B";
	mpdAddress = "127.0.0.1";
	mpdPort = 6600;
	mpdDataDir = "${globals.dir.mus}/.mpd";
	mpdVisName = "ncmpcpp visualizer feed";
	mpdVisPath = "${mpdDataDir}/visualizer.fifo";
	mpdVisStereo = true;
in {
	hm.home.packages = with pkgs; [
		yt-dlp
		ffmpeg
		mpc-cli

		chromaprint
		python312Packages.pyacoustid
		python312Packages.requests
		python312Packages.beautifulsoup4
		python312Packages.pylast
	];

	# {{{ mpv
	hm.programs.mpv = {
		enable = true;
		scripts = with pkgs; [
			mpvScripts.uosc
			mpvScripts.mpris
			mpvScripts.thumbfast
			mpvScripts.sponsorblock
			mpvScripts.cutter
		];
	};
	# }}}

	# {{{ mpd
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
				name   "${mpdVisName}"
				path   "${mpdVisPath}"
				format "44100:16:${if mpdVisStereo then "2" else "1"}"
			}
		'';
	};

	hm.services.mpd-mpris = {
		enable = true;
		mpd.useLocal = true;
	};

	sops.secrets.lastfm-pw = {
		sopsFile = ./Secrets.yaml;
		owner = "root";
		group = "root";
		mode = "0400";
		restartUnits = [ "mpdscribble.service" ];
	};
	services.mpdscribble = {
		enable = true;
		host = mpdAddress;
		port = mpdPort;
		endpoints = {
			"last.fm" = {
				username = lfmUser;
				passwordFile = config.sops.secrets.lastfm-pw.path;
			};
		};
	};
	# }}}

	# {{{ ncmpcpp
	hm.programs.ncmpcpp = {
		enable = true;
		package = pkgs.ncmpcpp.override { visualizerSupport = true; };
		mpdMusicDir = globals.dir.mus;
		settings = {
			mpd_host = mpdAddress;
			mpd_port = mpdPort;
			lyrics_directory = "${mpdDataDir}/lyrics";

			visualizer_output_name = mpdVisName;
			visualizer_data_source = mpdVisPath;
			visualizer_in_stereo = if mpdVisStereo then "yes" else "no";

			visualizer_type = "wave_filled";
			visualizer_look = "●█";
			visualizer_spectrum_dft_size = 1;

			# ncmpcpp's 256color needs to add one to the number (color 247 is written as 248)
			current_item_prefix = "$(green_248)";
			current_item_suffix = "$(end)";
			current_item_inactive_column_prefix = "$(green_255)";
			current_item_inactive_column_suffix = "$(end)";
			selected_item_prefix = "$(magenta_251)";
			selected_item_suffix = "$(end)";
			modified_item_prefix = "$(green)+ $(end)";
			alternative_header_second_line_format =
				"{{$(blue)$b{%a}$/b$(end)}{ - $(cyan)%b$(end)}{ ($(yellow)%y$(end))}}|{%D}";
			song_columns_list_format =
				"(20)[blue]{a} (4f)[white]{NE} (50)[green]{t|f} (20)[cyan]{b} (5f)[magenta]{lr}";
			song_window_title_format = "{%a - }{%t}|{%f}";
			browser_sort_mode = "format";
			browser_sort_format = "{%n}|{%t}|{%b}|{%f}";

			user_interface = "alternative";
			playlist_display_mode = "columns";
			browser_display_mode = "columns";
			search_engine_display_mode = "columns";
			playlist_editor_display_mode = "columns";
			display_bitrate = "yes";
			titles_visibility = "no";
			show_duplicate_tags = "no";
			connected_message_on_startup = "no";
			empty_tag_color = "red";
			main_window_color = "white";
			progressbar_color = "255";
			progressbar_elapsed_color = "magenta";
			progressbar_look = "──";
			tags_separator = " + ";

			volume_change_step = 4;
			screen_switcher_mode = "playlist";
			external_editor = "vim";
			data_fetching_delay = "no";
			ignore_diacritics = "yes";
			ignore_leading_the = "no";

			# TODO: move this to the ags shell (using playerctl lib) eventually
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
	# }}}

	# {{{ beets
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
			fetchart.auto = "no";

			bpm.max_strokes = 10;
			replaygain = {
				backend = "ffmpeg";
			};

			types.rating = "int";
		};
	};
	# }}}
}
