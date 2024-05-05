{ config, functions, theme, ... }:

{
	my.programs.sioyek = {
		enable = true;

		bindings = {
			# {{{ keybindings
			# misc
			open_link    = "L";
			copy         = "y";
			command      = "<C-space>";
			close_window = [ "q" "ZZ" "ZQ" ];

			# reading
			toggle_custom_color    = [ "<A-d>" "<C-r>" ];
			toggle_fastread        = "f";
			enter_visual_mark_mode = "V";
			close_visual_mark      = "<C-c>";

			# highlights
			delete_highlight_under_cursor   = "dH";
			set_highlight_with_current_type = "H";
			set_select_highlight_type       = "<C-S-t>";

			# search
			regex_search   = "<C-/>";
			chapter_search = "?";

			# navigation
			move_right            = "h"; # right means move the page right, not the view right
			move_down             = "j";
			move_up               = "k";
			move_left             = "l";
			move_visual_mark_down = "<C-j>";
			move_visual_mark_up   = "<C-k>";
			goto_top_of_page      = "<C-h>";
			goto_bottom_of_page   = "<C-l>";
			screen_down           = "J";
			screen_up             = "K";
			# }}}
		};

		config = with theme.colors;
			let
				dpi = functions.dpi config;
				color = c: functions.RGBConcat (functions.hexToFloatRGB c) " ";
				coloro = c: o: "${color c} ${toString o}";
			in
		{
			# {{{ options
			ruler_mode                       = "1";
			collapsed_toc                    = "1";
			should_launch_new_window         = "1";
			should_launch_new_instance       = "1";
			sort_bookmarks_by_location       = "1";
			check_for_updates_on_startup     = "0";
			multiline_menus                  = "1";
			prerender_next_page_presentation = "1";
			highlight_middle_click           = "1";
			super_fast_search                = "1";
			case_sensitive_search            = "0";

			font_size            = toString (dpi 18);
			status_bar_font_size = toString (dpi 18);
			fastread_opacity     = "0.7";
			vertical_move_amount = toString (dpi 0.53);

			ui_font          = theme.font.mono;
			startup_commands = "toggle_custom_color";
			# }}}

			# {{{ colors
			# primary
			background_color             = color bg1;
			dark_mode_background_color   = color bg1;
			ui_text_color                = color fg2;
			ui_background_color          = color bg2;
			ui_selected_text_color       = color bg1;
			ui_selected_background_color = color green;
			text_highlight_color         = color purple;
			link_highlight_color         = color cyan;

			vertical_line_color          = coloro bg2 0.3;
			visual_mark_color            = coloro bg2 0.3;
			status_bar_color             = color bg2;
			status_bar_text_color        = color fg2;

			# recolor
			custom_text_color                        = color fg1;
			custom_background_color                  = color bg1;
			custom_color_mode_empty_background_color = color bg1;

			# highlights
			highlight_color_a = color red;
			highlight_color_b = color orange;
			highlight_color_c = color yellow;
			highlight_color_d = color green;
			highlight_color_e = color cyan;
			highlight_color_f = color blue;
			highlight_color_g = color purple;
			# }}}
		};
	};
}
