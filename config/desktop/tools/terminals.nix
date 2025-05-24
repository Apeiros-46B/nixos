{ inputs, lib, pkgs, system, theme, ... }:

let
	# custom extension, defined below
	urxvtOsc52Ext = "52-osc";
	urxvtExts = lib.concatStringsSep "," [
		"default"
		"-confirm-paste" # disable paste confirmation
		 urxvtOsc52Ext
	];
in {
	# {{{ foot
	hm.programs.foot = {
		enable = true;
		settings = {
			main = {
				font = "${theme.font.mono}:pixelsize=18,${theme.font.mono_fallback}:pixelsize=18";
				line-height = "22px";
				underline-offset = "2px";
				pad = "20x20";
			};
			scrollback.indicator-position = "none";
			cursor.unfocused-style = "hollow";
			colors = with theme.colors; {
				background = bg0;
				foreground = fg0;
				regular0   = bg0;
				regular1   = red;
				regular2   = green;
				regular3   = yellow;
				regular4   = blue;
				regular5   = purple;
				regular6   = aqua;
				regular7   = fg3;
				bright0    = bg2;
				bright1    = red;
				bright2    = green;
				bright3    = yellow;
				bright4    = blue;
				bright5    = purple;
				bright6    = aqua;
				bright7    = fg3;
				dim0       = fg0;
				dim1       = red;
				dim2       = green;
				dim3       = yellow;
				dim4       = blue;
				dim5       = purple;
				dim6       = aqua;
				dim7       = fg3;
				"232"      = bg0;
				"233"      = bg1;
				"234"      = bg2;
				"235"      = bg3;
				"236"      = bg4;
				"237"      = bg5;
				"238"      = fg0;
				"239"      = fg1;
				"240"      = fg2;
				"241"      = fg3;
				"243"      = orange;
				"244"      = bgRed;
				"246"      = bgYellow;
				"247"      = bgGreen;
				"249"      = bgBlue;
				"250"      = bgPurple;
			};
			tweak.box-drawing-base-thickness = 0.03;
		};
	};
	# }}}

	# {{{ urxvt
	hm.programs.urxvt = {
		enable = true;
		fonts = [ "xft:tewi:pixelsize=22" ];
		scroll = {
			bar.enable = false;
			keepPosition = true;
			lines = 10000;
			scrollOnKeystroke = true;
			scrollOnOutput = false;
		};
		keybindings = {
			Shift-Control-C = "eval:selection_to_clipboard";
			Shift-Control-V = "eval:paste_clipboard";
		};
		iso14755 = false;
		extraConfig = {
			iso14755_52 = false;
			internalBorder = 20;
			perl-ext-common = urxvtExts;
		};
	};

	# https://unix.stackexchange.com/questions/629398/does-urxvt-support-the-osc52-escape-sequence
	hm.home.file.".urxvt/ext/${urxvtOsc52Ext}".text = ''
		#!${pkgs.perl}/bin/perl

		use MIME::Base64;
		use Encode;

		sub on_osc_seq {
			my ($term, $op, $args) = @_;
			return () unless $op eq 52;
			my ($clip, $data) = split ';', $args, 2;
			if ($data eq '?') {
				my $data_free = $term->selection();
				Encode::_utf8_off($data_free); # XXX
					$term->tt_write("\e]52;$clip;".encode_base64($data_free, ''')."\a");
			}
			else {
				my $data_decoded = decode_base64($data);
				Encode::_utf8_on($data_decoded); # XXX
					$term->selection($data_decoded, $clip =~ /c/);
				$term->selection_grab(urxvt::CurrentTime, $clip =~ /c/);
			}
			()
		}
	'';
	# }}}

	hm.home.packages = [ inputs.st.packages.${system}.st-snazzy ];
}
