{ pkgs, theme, ... }:

{
	hm.programs.fuzzel = {
		enable = true;
		settings = {
			main = {
				font = "${theme.font.sans}:size=13";
				terminal = "${pkgs.foot}/bin/foot";

				use-bold = true;
				show-actions = true;
				icons-enabled = false;

				width = 60;
				lines = 25;
				tabs = 2;
				horizontal-pad = 40;
				vertical-pad = 40;
			};
			border = {
				width = 0;
				radius = 0;
			};
			colors = with builtins.mapAttrs (k: v: "${v}ff") theme.colors; {
				background = bg1;
				text = fg0;
				prompt = orange;
				placeholder = fg3;
				input = fg0;
				match = blue;
				selection = bgBlue;
				selection-text = fg0;
				selection-match = blue;
			};
		};
	};
}
