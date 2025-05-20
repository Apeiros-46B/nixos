{ pkgs, theme, ... }:

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

	environment.systemPackages = [ pkgs.oomoxFull ];

	hm.gtk = let
		oomox = pkgs.oomoxPlugins;
		themeDef = with theme.colors; pkgs.writeText "${theme.name}.theme" ''
			ACCENT_BG=${blue}
			BASE16_GENERATE_DARK=False
			BASE16_INVERT_TERMINAL=False
			BASE16_MILD_TERMINAL=False
			BG=${bg1}
			BTN_BG=${bg2}
			BTN_FG=${bg1}
			BTN_OUTLINE_OFFSET=10
			BTN_OUTLINE_WIDTH=1
			CARET1_FG=${purple}
			CARET2_FG=${bg4}
			CARET_SIZE=0.04
			CINNAMON_OPACITY=1.0
			FG=${fg1}
			GRADIENT=0.0
			GTK3_GENERATE_DARK=True
			HDR_BG=${bg2}
			HDR_BTN_BG=${bg3}
			HDR_BTN_FG=${fg1}
			HDR_FG=${fg1}
			ICONS_ARCHDROID=${bg5}
			ICONS_DARK=${bg2}
			ICONS_LIGHT=${blue}
			ICONS_LIGHT_FOLDER=${blue}
			ICONS_MEDIUM=${blue}
			ICONS_NUMIX_STYLE=4
			ICONS_STYLE=papirus_icons
			ICONS_SYMBOLIC_ACTION=${blue}
			ICONS_SYMBOLIC_PANEL=${blue}
			MATERIA_PANEL_OPACITY=0.6
			MATERIA_SELECTION_OPACITY=0.2
			MATERIA_STYLE_COMPACT=True
			MENU_BG=${bg3}
			MENU_FG=${fg1}
			NAME="elysium-gtk"
			OUTLINE_WIDTH=1
			ROUNDNESS=0
			SEL_BG=${blue}
			SEL_FG=${bg1}
			SPACING=3
			SURUPLUS_GRADIENT1=${blue}
			SURUPLUS_GRADIENT2=${blue}
			SURUPLUS_GRADIENT_ENABLED=False
			TERMINAL_ACCENT_COLOR=${blue}
			TERMINAL_BACKGROUND=${bg1}
			TERMINAL_BASE_TEMPLATE=basic
			TERMINAL_COLOR0=${bg1}
			TERMINAL_COLOR1=${red}
			TERMINAL_COLOR10=${green}
			TERMINAL_COLOR11=${yellow}
			TERMINAL_COLOR12=${blue}
			TERMINAL_COLOR13=${purple}
			TERMINAL_COLOR14=${cyan}
			TERMINAL_COLOR15=${fg1}
			TERMINAL_COLOR2=${green}
			TERMINAL_COLOR3=${yellow}
			TERMINAL_COLOR4=${blue}
			TERMINAL_COLOR5=${purple}
			TERMINAL_COLOR6=${cyan}
			TERMINAL_COLOR7=${fg1}
			TERMINAL_COLOR8=${bg3}
			TERMINAL_COLOR9=${red}
			TERMINAL_CURSOR=${fg1}
			TERMINAL_FOREGROUND=${fg1}
			TERMINAL_THEME_ACCURACY=128
			TERMINAL_THEME_AUTO_BGFG=False
			TERMINAL_THEME_EXTEND_PALETTE=True
			TERMINAL_THEME_MODE=manual
			THEME_STYLE=materia
			TXT_BG=${bg2}
			TXT_FG=${fg1}
			UNITY_DEFAULT_LAUNCHER_STYLE=False
			WM_BORDER_FOCUS=${blue}
			WM_BORDER_UNFOCUS=${fg2}
		'';
	in {
		enable = true;
		font = {
			name = theme.font.sans;
			size = 11;
		};
		iconTheme = rec {
			name = "${theme.name}-icons";
			package = (oomox.icons-papirus.generate {
				src = themeDef;
				inherit name;
			});
		};
		theme = rec {
			name = "${theme.name}-gtk";
			package = (oomox.theme-materia.generate {
				src = themeDef;
				inherit name;
			});
		};
	};
}
