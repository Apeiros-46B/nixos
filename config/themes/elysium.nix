rec {
	name = "elysium";
	dark = false;
	colors = {
		bg1 = "ffffff";
		bg2 = "f4f4f4";
		bg3 = "ebebeb";
		bg4 = "e4e4e4";
		bg5 = "dfdfdf";
		bg6 = "dcdcdc";

		bgVisual = "e4dce8";
		bgRed    = "e9dbdf";
		bgGreen  = "d9e3d7";
		bgBlue   = "dddfeb";
		bgYellow = "f0e6d8";

		fg1 = "333333";
		fg2 = "777777";
		fg3 = "888888";
    fg4 = "555555";

		red    = "904961";
		orange = "934c3d";
		yellow = "b5803e";
		green  = "427138";
		cyan   = "117555";
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
