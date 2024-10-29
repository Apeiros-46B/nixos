{ pkgs, functions, ... }:

functions.linkDots "emacs" {
	hm.programs.emacs.enable = true;
	hm.home.packages = [ pkgs.texlive.combined.scheme-full ];
}
