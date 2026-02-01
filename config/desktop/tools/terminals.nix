{ inputs, system, theme, ... }:

{
	# {{{ foot
	hm.programs.foot = {
		enable = true;
		settings = {
			main = {
				font = "${theme.font.mono}:size=13.5,${theme.font.mono_fallback}:size=13.5";
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
				"242"      = bgShade;
				"243"      = orange;
				"244"      = bgRed;
				"246"      = bgYellow;
				"247"      = bgGreen;
				"248"      = bgAqua;
				"249"      = bgBlue;
				"250"      = bgPurple;
			};
			tweak.box-drawing-base-thickness = 0.03;
		};
	};
	# }}}

	# {{{ st
	hm.home.packages = [ inputs.st.packages.${system}.st-snazzy ];
	hm.programs.zsh.initContent = with theme.colorsHash; ''
		if [ $TERM = "st-256color" ]; then
			echo -ne '\e]4;232;${bg0}\a'
			echo -ne '\e]4;233;${bg1}\a'
			echo -ne '\e]4;234;${bg2}\a'
			echo -ne '\e]4;235;${bg3}\a'
			echo -ne '\e]4;236;${bg4}\a'
			echo -ne '\e]4;237;${bg5}\a'
			echo -ne '\e]4;238;${fg0}\a'
			echo -ne '\e]4;239;${fg1}\a'
			echo -ne '\e]4;240;${fg2}\a'
			echo -ne '\e]4;241;${fg3}\a'
			echo -ne '\e]4;243;${orange}\a'
			echo -ne '\e]4;244;${bgRed}\a'
			echo -ne '\e]4;246;${bgYellow}\a'
			echo -ne '\e]4;247;${bgGreen}\a'
			echo -ne '\e]4;248;${bgAqua}\a'
			echo -ne '\e]4;249;${bgBlue}\a'
			echo -ne '\e]4;250;${bgPurple}\a'
		fi
	'';
	# }}}
}
