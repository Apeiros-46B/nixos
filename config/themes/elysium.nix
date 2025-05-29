rec {
	name = "elysium";
	dark = false;
	colors = {
		bg0 = "ffffff";
		bg1 = "f4f4f4";
		bg2 = "ebebeb";
		bg3 = "e4e4e4";
		bg4 = "dfdfdf";
		bg5 = "dcdcdc";

		bgPurple = "e4dce8";
		bgRed    = "e9dbdf";
		bgGreen  = "d9e3d7";
		bgBlue   = "dddfeb";
		bgYellow = "f0e6d8";

		fg0 = "333333";
		fg1 = "202020";
		fg2 = "000000";
		fg3 = "777777";
		fg4 = "555555";

		red    = "904961";
		orange = "934c3d";
		yellow = "b5803e";
		green  = "427138";
		aqua   = "117555";
		blue   = "535d9c";
		purple = "79508a";
	};
	colorsHash = builtins.mapAttrs (k: v: "#${v}") colors;
	font = {
		serif = "IBM Plex Serif";
		sans = "IBM Plex Sans";
		mono = "Iosevka Custom";
		mono_fallback = "Iosevka Nerd Font Mono";
	};
}
