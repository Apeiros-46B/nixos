rec {
	colors = {
		bg1 = "2b3339";
		bg2 = "323c41";
		bg3 = "3a454a";
		bg4 = "445055";
		bg5 = "4c555b";
		bg6 = "53605c";

		bgVisual = "503946";
		bgRed    = "4e3e43";
		bgGreen  = "404d44";
		bgBlue   = "394f5a";
		bgYellow = "4a4940";

		fg1 = "d3c6aa";
		fg2 = "859289";
		fg3 = "7a8478";
    fg4 = "9da9a0";

		red    = "e67e80";
		orange = "e69875";
		yellow = "dbbc7f";
		green  = "a7c080";
		cyan   = "83c092";
		blue   = "7fbbb3";
		purple = "d699b6";
	};
	colorsHash = builtins.mapAttrs (k: v: "#${v}") colors;
	# TODO: custom iosevka build
	font = {
		serif = "IBM Plex Serif";
		sans = "IBM Plex Sans";
		mono = "JetBrainsMono Nerd Font Mono";
		mono2 = "Iosevka Nerd Font Mono";
	};
}
