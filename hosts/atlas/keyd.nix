{ ... }:

{
	services.keyd = {
		enable = true;

		keyboards = {
			default = {
				ids = [
					"0001:0001"
				];
				settings = {
					main = {
						capslock = "esc";
						esc = "capslock";
					};
					altgr = {
						h = "left";
						j = "down";
						k = "up";
						l = "right";
						w = "C-right";
						b = "C-left";
						g = "home";
						p = "pageup";
						n = "pagedown";
						r = "S-right";
						x = "delete";
					};
					"altgr+shift" = {
						g = "end";
					};
				};
			};
		};
	};
}
