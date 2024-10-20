{ ... }:

{
	hm.programs.urxvt = {
		enable = true;
		fonts = [ "xft:tewi:pixelsize=22" ];
		scroll = {
			bar.enable = false;
			keepPosition = true;
			lines = 10000;
		};
		keybindings = {
			"Shift-Control-C" = "eval:selection_to_clipboard";
			"Shift-Control-V" = "eval:paste_clipboard";
		};
	};
}
