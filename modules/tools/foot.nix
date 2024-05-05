{ pkgs, ... }:

{
	fonts.packages = [ pkgs.tewi-font ];

	# TODO:
	my.programs.foot = {
		enable = true;
		server.enable = true;
		settings = {
			main = {
				term = "xterm-256color";
				font = "tewi:pixelsize=22";
				dpi-aware = "no";
			};
			mouse = {
				hide-when-typing = "no";
			};
		};
	};
}
