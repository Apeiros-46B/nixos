{ pkgs, theme, ... }:

{
	hm.xresources.properties = with theme.colorsHash; {
		"*.foreground"  = fg0;
		"*.background"  = bg0;
		"*.cursorColor" = fg0;
		"*.color0"      = bg0;
		"*.color8"      = bg2;
		"*.color1"      = red;
		"*.color9"      = red;
		"*.color2"      = green;
		"*.color10"     = green;
		"*.color3"      = yellow;
		"*.color11"     = yellow;
		"*.color4"      = blue;
		"*.color12"     = blue;
		"*.color5"      = purple;
		"*.color13"     = purple;
		"*.color6"      = aqua;
		"*.color14"     = aqua;
		"*.color7"      = fg3;
		"*.color15"     = fg0;
	};

	# TODO: this doesn't build, causes wrapGApps renamed thing
	# environment.systemPackages = [ pkgs.oomoxFull ];

	hm.gtk = let
		oomox = pkgs.oomoxPlugins;
		themeDef = with theme.colors; pkgs.writeText "${theme.name}.theme" ''
			ACCENT_BG=${blue}
			BASE16_GENERATE_DARK=False
			BASE16_INVERT_TERMINAL=False
			BASE16_MILD_TERMINAL=False
			BG=${bg0}
			BTN_BG=${bg1}
			BTN_FG=${bg0}
			BTN_OUTLINE_OFFSET=10
			BTN_OUTLINE_WIDTH=1
			CARET1_FG=${purple}
			CARET2_FG=${purple}
			CARET_SIZE=0.05
			CINNAMON_OPACITY=1.0
			FG=${fg0}
			GRADIENT=0.0
			GTK3_GENERATE_DARK=True
			HDR_BG=${bg1}
			HDR_BTN_BG=${bg2}
			HDR_BTN_FG=${fg0}
			HDR_FG=${fg4}
			ICONS_ARCHDROID=${blue}
			ICONS_DARK=${bg1}
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
			MENU_BG=${bg2}
			MENU_FG=${fg0}
			NAME="${theme.name}-gtk"
			OUTLINE_WIDTH=0
			ROUNDNESS=0
			SEL_BG=${blue}
			SEL_FG=${fg0}
			SPACING=3
			SURUPLUS_GRADIENT1=${blue}
			SURUPLUS_GRADIENT2=${blue}
			SURUPLUS_GRADIENT_ENABLED=False
			TERMINAL_ACCENT_COLOR=${blue}
			TERMINAL_BACKGROUND=${bg0}
			TERMINAL_BASE_TEMPLATE=basic
			TERMINAL_COLOR0=${bg0}
			TERMINAL_COLOR1=${red}
			TERMINAL_COLOR10=${green}
			TERMINAL_COLOR11=${yellow}
			TERMINAL_COLOR12=${blue}
			TERMINAL_COLOR13=${purple}
			TERMINAL_COLOR14=${aqua}
			TERMINAL_COLOR15=${fg0}
			TERMINAL_COLOR2=${green}
			TERMINAL_COLOR3=${yellow}
			TERMINAL_COLOR4=${blue}
			TERMINAL_COLOR5=${purple}
			TERMINAL_COLOR6=${aqua}
			TERMINAL_COLOR7=${fg0}
			TERMINAL_COLOR8=${bg2}
			TERMINAL_COLOR9=${red}
			TERMINAL_CURSOR=${fg0}
			TERMINAL_FOREGROUND=${fg0}
			TERMINAL_THEME_ACCURACY=128
			TERMINAL_THEME_AUTO_BGFG=False
			TERMINAL_THEME_EXTEND_PALETTE=True
			TERMINAL_THEME_MODE=manual
			THEME_STYLE=materia
			TXT_BG=${bg1}
			TXT_FG=${fg0}
			UNITY_DEFAULT_LAUNCHER_STYLE=False
			WM_BORDER_FOCUS=${bg0}
			WM_BORDER_UNFOCUS=${bg0}
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
