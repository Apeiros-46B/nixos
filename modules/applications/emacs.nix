{ pkgs, functions, ... }:

functions.linkDots "emacs" {
	my.programs.emacs.enable = true;
	my.home.packages = [ pkgs.texlive.combined.scheme-full ];
}
