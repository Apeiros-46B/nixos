{ theme, ... }:

{
	hm.xresources.properties = {
		"*.foreground"  = theme.colorsHash.fg1;
		"*.background"  = theme.colorsHash.bg1;
		"*.cursorColor" = theme.colorsHash.fg1;
		"*.color0"      = theme.colorsHash.bg1;
		"*.color8"      = theme.colorsHash.bg3;
		"*.color1"      = theme.colorsHash.red;
		"*.color9"      = theme.colorsHash.red;
		"*.color2"      = theme.colorsHash.green;
		"*.color10"     = theme.colorsHash.green;
		"*.color3"      = theme.colorsHash.yellow;
		"*.color11"     = theme.colorsHash.yellow;
		"*.color4"      = theme.colorsHash.blue;
		"*.color12"     = theme.colorsHash.blue;
		"*.color5"      = theme.colorsHash.purple;
		"*.color13"     = theme.colorsHash.purple;
		"*.color6"      = theme.colorsHash.cyan;
		"*.color14"     = theme.colorsHash.cyan;
		"*.color7"      = theme.colorsHash.fg2;
		"*.color15"     = theme.colorsHash.fg1;
	};

	# TODO: gtk
}
