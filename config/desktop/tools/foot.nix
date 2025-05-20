{ theme, ... }:

{
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
				background = bg1;
				foreground = fg1;
				regular0   = bg1;
				regular1   = red;
				regular2   = green;
				regular3   = yellow;
				regular4   = blue;
				regular5   = purple;
				regular6   = cyan;
				regular7   = fg2;
				bright0    = bg3;
				bright1    = red;
				bright2    = green;
				bright3    = yellow;
				bright4    = blue;
				bright5    = purple;
				bright6    = cyan;
				bright7    = fg2;
				dim0       = fg1;
				dim1       = red;
				dim2       = green;
				dim3       = yellow;
				dim4       = blue;
				dim5       = purple;
				dim6       = cyan;
				dim7       = fg2;
				"244"      = bgRed;
				"246"      = bgYellow;
				"247"      = bgGreen;
				"249"      = bgBlue;
				"250"      = bgVisual;
			};
			tweak.box-drawing-base-thickness = 0.03;
		};
	};
}
