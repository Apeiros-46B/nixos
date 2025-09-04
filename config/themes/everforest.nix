rec {
	name = "everforest";
	dark = true;
	colors = {
		bg0     = "2b3339";
		bg1     = "323c41";
		bg2     = "3a454a";
		bg3     = "445055";
		bg4     = "4c555b";
		bg5     = "53605c";
		bgShade = "2d373d";

		bgPurple = "503946";
		bgRed    = "4e3e43";
		bgGreen  = "404d44";
		bgAqua   = "455956";
		bgBlue   = "394f5a";
		bgYellow = "4a4940";

		fg0 = "d3c6aa";
		fg1 = "d3c6aa";
		fg2 = "d3c6aa";
		fg3 = "859289";
		fg4 = "9da9a0";

		red    = "e67e80";
		orange = "e69875";
		yellow = "dbbc7f";
		green  = "a7c080";
		aqua   = "83c092";
		blue   = "7fbbb3";
		purple = "d699b6";
	};
	colorsHash = builtins.mapAttrs (k: v: "#${v}") colors;
	font = {
		serif = "IBM Plex Serif";
		sans = "IBM Plex Sans";
		mono = "Iosevka Custom";
		mono_fallback = "Iosevka Nerd Font Mono";
	};
}
