rec {
	name = "elysium";
	dark = false;
	colors = {
		bg0     = "ffffff";
		bg1     = "f4f4f4";
		bg2     = "ebebeb";
		bg3     = "e4e4e4";
		bg4     = "dfdfdf";
		bg5     = "dcdcdc";
		bgShade = "fafafa";

		bgPurple = "e4dce8";
		bgRed    = "e9dbdf";
		bgGreen  = "dce2da";
		bgAqua   = "d5e2e5";
		bgBlue   = "dddfeb";
		bgYellow = "f0e6d9";

		fg0 = "333333";
		fg1 = "202020";
		fg2 = "000000";
		fg3 = "777777";
		fg4 = "555555";

		red    = "904961";
		orange = "90502a";
		yellow = "b38143";
		green  = "546b4f";
		aqua   = "406b75";
		blue   = "535d9c";
		purple = "79508a";
	};
	colorsHash = builtins.mapAttrs (k: v: "#${v}") colors;
	font = {
		serif = "IBM Plex Serif";
		sans = "IBM Plex Sans";
		mono = "Iosevka Custom";
		mono_fallback = "Iosevka Nerd Font Mono";
		emoji = "Twitter Color Emoji";
	};
}
