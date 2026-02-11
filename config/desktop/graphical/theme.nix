{ pkgs, theme, ... }:

let
	gtkThemeName = "${theme.name}-gtk";
in {
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
	# i think we need to fork the nixmox repo and fix it there?
	# environment.systemPackages = [ pkgs.oomoxFull ];

	hm.home.sessionVariables.GTK_THEME = gtkThemeName;
	hm.dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = if theme.dark then "prefer-dark" else "default";
    };
  };

	hm.gtk = let
		oomox = pkgs.oomoxPlugins;
		darkBool = if theme.dark then "True" else "False";
		themeDef = with theme.colors; pkgs.writeText "${theme.name}.theme" ''
			ACCENT_BG=${bgBlue}
			BASE16_GENERATE_DARK=${darkBool}
			BASE16_INVERT_TERMINAL=False
			BASE16_MILD_TERMINAL=False
			BG=${bg0}
			BTN_BG=${bg1}
			BTN_FG=${fg0}
			BTN_OUTLINE_OFFSET=10
			BTN_OUTLINE_WIDTH=1
			CARET1_FG=${purple}
			CARET2_FG=${purple}
			CARET_SIZE=0.05
			CINNAMON_OPACITY=1.0
			FG=${fg0}
			GRADIENT=0.0
			GTK3_GENERATE_DARK=${darkBool}
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
			MATERIA_SELECTION_OPACITY=1.0
			MATERIA_STYLE_COMPACT=True
			MENU_BG=${bg2}
			MENU_FG=${fg0}
			NAME=${gtkThemeName}
			OUTLINE_WIDTH=0
			ROUNDNESS=0
			SEL_BG=${bgBlue}
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
		''; # NOTE: if there's problems with sel fg in thunar sidebar, reset materia select opacity to 0.2 and investigate SEL_*
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
			name = gtkThemeName;
			package = (oomox.theme-materia.generate {
				src = themeDef;
				inherit name;
			});
		};
		gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = if theme.dark then 1 else 0;
    };
		# gtk3.extraCss = with theme.colorsHash; ''
		#     .view:selected,
		#     .view:selected:focus,
		#     .sidebar :selected,
		#     iconview:selected {
		#         background-color: ${bgBlue} !important;
		#         color: ${fg0} !important;
		#         outline-color: transparent;
		#     }
		#     entry selection, entry:selected {
		#         background-color: ${blue};
		#         color: ${bg0};
		#     }
		#   '';
		gtk3.extraCss = with theme.colorsHash; ''
			* {
				caret-color: ${blue};
				box-shadow: none;
			}

			/* TODO: fix borders persisting in some places */
			/* TODO: fix QL EQ plugin presents pane having the wrong bg color */
			frame, .frame {
				background-color: ${bg0};
				border: none;
				box-shadow: none;
			}

			headerbar,
			headerbar:backdrop,
			.titlebar,
			.titlebar:backdrop {
				background-color: ${bg1};
				color: ${fg0};
				box-shadow: none;
				border-bottom: none;
			}
			headerbar button {
				color: ${fg3};
			}
			menubar {
				background-color: ${bg1};
			}
			tab {
				color: ${fg0};
			}
			tab:checked {
				color: ${blue};
				border-bottom: 2px ${blue};
			}

			button.image-button {
				color: ${fg3};
			}
			button.image-button:disabled {
				color: ${bg3};
			}
			button:not(.image-button) {
				background-color: ${bg1};
			}
			treeview button {
				color: ${fg3};
			}
			check, radio {
				color: ${bg3};
				border-color: ${fg3};
			}
			check:checked,
			check:active,
			radio:checked,
			radio:active,
			button:checked,
			button:active,
			.linked button:checked,
			toolbutton:checked,
			toolbutton:active {
				color: ${blue};
				border-color: ${blue};
				/* TODO: fix the color of the circle at the center of radio buttons */
			}
			switch {
				background-color: ${bg2};
			}
			switch slider {
				background-color: ${bg3};
			}
			switch:checked {
				background-color: ${bgBlue};
			}
			switch:checked slider {
				background-color: ${blue};
			}

			entry {
				background-color: ${bgShade};
				border-image-source: radial-gradient(
					circle closest-corner at center calc(-1px + 100%),
					${blue} 0%,
					${blue} 0%,
					transparent 0%
				);
			}
			entry:focus {
				border-image-source: radial-gradient(
					circle closest-corner at center
					calc(-1px + 100%),
					${blue} 0%,
					${blue} 100%,
					transparent 100%
				);
			}

			selection {
				color: ${fg0};
				background-color: ${bgPurple};
			}

			link {
				color: ${purple};
				border-bottom-color: ${purple};
			}

			/* {{{ very sloppy needs cleanup */
			/* gimp buttons */
			button:disabled > image,
			button:disabled > box {
				color: ${bg3};
			}
			button > image,
			button > box {
				color: ${fg3};
			}
			button:active > image,
			button:selected > image,
			button:checked > image {
				color: ${blue};
			}

			/* QL controls */
			/* idk if this selector can be made more specific. QL doesn't expose names or classes
				 that let us make a selector that is guaranteed to only match QL widgets */
			window > box.vertical > toolbar.horizontal > toolitem > box.vertical > widget > button.flat {
				background-color: ${bg0};
			}

			/* {{{ border stuff */
			scrolledwindow viewport.frame,
			scrolledwindow frame,
			scrolledwindow {
				border: none;
				box-shadow: none;
			}
			scrolledwindow junction {
				border: none;
				background-color: transparent;
			}
			scrollbar trough {
				border: none;
				background-color: transparent;
			}
			border,
			frame > border {
				border-color: ${bg1};
			}
			separator {
				color: ${bg1};
				background-color: ${bg1};
				min-height: 1px;
				min-width: 1px;
				opacity: 1;
			}
			paned > separator {
				background-color: ${bg1};
				min-width: 1px;
				min-height: 1px;
				background-image: none;
			}
			/* TODO: fix thunar column buttons and border colors */
			/* }}} */

			label:disabled {
				color: ${fg3};
			}
			/* TODO: fix pavucontrol sliders, i think its gtk4? */
			scale trough {
				background-color: ${bg2};
				border: none;
				background-image: none;
				box-shadow: none;
			}
			scale fill {
				background-color: ${bg2};
				border: none;
				background-image: none;
				box-shadow: none;
			}
			scale highlight {
				background-color: ${blue};
				border-radius: 99px;
				background-image: none;
				border: none;
				box-shadow: none;
			}
			scale:disabled highlight {
				background-color: ${fg3};
				opacity: 1;
			}

			menu menuitem:hover,
			menu menuitem:active,
			popover.menu button:not(.titlebutton):not(.image-button):hover,
			popover.menu modelbutton:hover,
			popover.menu flatbutton:hover,
			popover.menu checkbutton:hover,
			popover.menu radiobutton:hover,
			list row:hover,
			combobox list row:hover,
			flowbox flowboxchild:hover,
			row.sidebar-row:hover,
			placessidebar row:hover {
				background-image: none;
				background-color: alpha(${blue}, 0.2);
				color: ${fg0};
				border-color: transparent;
				box-shadow: none;
			}
			treeview.view:hover {
				background-color: inherit;
			}
			treeview.view {
				-gtk-tree-view-hover-background-color: alpha(${blue}, 0.20);
			}

			button:hover,
			button.image-button:hover,
			button.flat:hover,
			button.suggested-action:hover,
			button.destructive-action:hover,
			headerbar button:hover,
			toolbar button:hover,
			inline-toolbar button:hover,
			searchbar button:hover,
			actionbar button:hover {
				background-image: none;
				background-color: ${bg1};
			}

			/* TODO fix ugly halo around radio/check when hovering */
			menu menuitem:hover,
			menubar > item:hover,
			popover.menu button:hover,
			popover.menu modelbutton:hover,
			popover.menu flatbutton:hover,
			popover.menu checkbutton:hover,
			popover.menu radiobutton:hover {
				background-image: none;
				background-color: ${bg2};
			}

			list row:hover,
			combobox list row:hover,
			flowbox flowboxchild:hover,
			placessidebar row:hover,
			row.sidebar-row:hover,
			treeview.view:hover {
				background-image: none;
				background-color: ${bg1};
			}

			button.linked:hover,
			entry.linked > button:hover {
				background-image: none;
				background-color: ${bg2};
				z-index: 1;
			}

			list row:selected:hover,
			.view:selected:hover,
			iconview:selected:hover {
				background-color: ${bgBlue};
			}

			button.destructive-action:active:hover,
			button.destructive-action:checked:hover {
				background-color: ${red};
				color: ${bg0};
			}
			/* }}} end slop */
		'';
		gtk4.extraCss = with theme.colors; ''
      @define-color window_bg_color ${bg0};
      @define-color window_fg_color ${fg0};

      @define-color view_bg_color ${bg0};
      @define-color view_fg_color ${fg0};

      @define-color headerbar_bg_color ${bg1};
      @define-color headerbar_fg_color ${fg3};
      @define-color headerbar_backdrop_color @window_bg_color;

      @define-color card_bg_color ${bg2};
      @define-color card_fg_color ${fg0};
      @define-color popover_bg_color ${bg2};
      @define-color popover_fg_color ${fg0};

      @define-color dialog_bg_color ${bg1};
      @define-color dialog_fg_color ${fg0};

      @define-color accent_bg_color ${blue};
      @define-color accent_fg_color ${bg0};
      @define-color accent_color ${blue};

      @define-color destructive_bg_color ${red};
      @define-color destructive_fg_color ${bg0};
      @define-color destructive_color ${red};
    '';
	};

	hm.home.pointerCursor = {
		name = "phinger-cursors-light";
		package = pkgs.phinger-cursors;
		size = 24;
		gtk.enable = true;
		x11 = {
			enable = true;
			defaultCursor = "left_ptr";
		};
	};
}
