{ pkgs, theme, ... }:

{
	hm.programs.vicinae = {
		enable = true;
		systemd.enable = true;
		themes.system = {
			meta = {
				version = 1;
				name = "NixOS System";
				description = "Follows the system theme";
				variant = if theme.dark then "dark" else "light";
			};

			colors = with theme.colorsHash; {
				core = {
					background = bg1;
					foreground = fg0;
					secondary_background = bg2;
					border = "transparent";
					accent = bgBlue;
				};
				accents = {
					red = red;
					orange = orange;
					yellow = yellow;
					green = green;
					cyan = aqua;
					blue = blue;
					purple = purple;
					magenta = purple;
				};
				text = {
					default = fg0;
					muted = fg3;
					danger = fg2;
					success = fg2;
					placeholder = fg3;
					selection = {
						foreground = fg0;
						background = bgPurple;
					};
					links = {
						default = aqua;
						visited = purple;
					};
				};
				button.primary = {
					background = bg2;
					foreground = fg0;
					hover.background = bg3;
					focus.background = "colors.core.accent";
				};
				list.item.hover = {
					foreground = fg2;
					background = bg2;
				};
				list.item.selection = {
					foreground = fg2;
					background = bg2;
					secondary_foreground = fg2;
					secondary_background = bg3;
				};
				grid.item = {
					background = bg2;
					hover.outline.opacity = 0.0;
					selection.outline.opacity = 0.0;
				};
				scrollbars.background = bg3;
				loading = {
					bar = fg3;
					spinner = fg3;
				};
			};
		};
	};

	hm.programs.fuzzel = {
		enable = true;
		settings = {
			main = {
				font = "${theme.font.sans}:size=13";
				terminal = "${pkgs.foot}/bin/foot";

				use-bold = true;
				show-actions = true;
				icons-enabled = false;

				width = 60;
				lines = 25;
				tabs = 2;
				horizontal-pad = 40;
				vertical-pad = 40;
			};
			border = {
				width = 0;
				radius = 0;
			};
			colors = with builtins.mapAttrs (k: v: "${v}ff") theme.colors; {
				background = bg1;
				text = fg0;
				prompt = orange;
				placeholder = fg3;
				input = fg0;
				match = blue;
				selection = bgBlue;
				selection-text = fg0;
				selection-match = blue;
			};
		};
	};
}
