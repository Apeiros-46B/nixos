{ theme, ... }:

let
	colors = builtins.mapAttrs (k: v: "#${v}") theme.colors;
in {
	my.programs.alacritty = {
		enable = true;
		settings = {
			window.padding = {
				x = 20;
				y = 20;
			};
			colors = with colors; rec {
				primary = {
					foreground = fg1;
					dim_foreground = fg2;
					background = bg1;
				};
				normal = {
					white = fg1;
					black = bg3;
					magenta = purple; # color name difference
					inherit red yellow green cyan blue;
				};
				bright = normal;
				dim = normal;
			};
			font = {
				size = 13;

				normal.family = "JetBrainsMono Nerd Font Mono";
				bold.family = "JetBrainsMono Nerd Font Mono";
				italic.family = "JetBrainsMono Nerd Font Mono";
				bold_italic.family = "JetBrainsMono Nerd Font Mono";
			};
		};
	};
}
