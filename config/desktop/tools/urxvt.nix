{ lib, pkgs, ... }:

let
	extensions = lib.concatStringsSep "," [
		"default"
		"52-osc" # custom
		"-confirm-paste" # disable paste confirmation
	];
in {
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
			perl-ext-common = extensions;
		};
	};

	# https://unix.stackexchange.com/questions/629398/does-urxvt-support-the-osc52-escape-sequence
	hm.home.file.".urxvt/ext/52-osc".text = ''
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
}
