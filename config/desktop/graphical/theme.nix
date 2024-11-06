{ theme, ... }:

{
	hm.xresources.properties = {
		"*.foreground"  = theme.colors_hash.fg1;
		"*.background"  = theme.colors_hash.bg1;
		"*.cursorColor" = theme.colors_hash.fg1;
		"*.color0"      = theme.colors_hash.bg3;
		"*.color8"      = theme.colors_hash.fg2;
		"*.color1"      = theme.colors_hash.red;
		"*.color9"      = theme.colors_hash.red;
		"*.color2"      = theme.colors_hash.green;
		"*.color10"     = theme.colors_hash.green;
		"*.color3"      = theme.colors_hash.yellow;
		"*.color11"     = theme.colors_hash.yellow;
		"*.color4"      = theme.colors_hash.blue;
		"*.color12"     = theme.colors_hash.blue;
		"*.color5"      = theme.colors_hash.purple;
		"*.color13"     = theme.colors_hash.purple;
		"*.color6"      = theme.colors_hash.cyan;
		"*.color14"     = theme.colors_hash.cyan;
		"*.color7"      = theme.colors_hash.fg1;
		"*.color15"     = theme.colors_hash.fg1;
	};

	# TODO: gtk
}
