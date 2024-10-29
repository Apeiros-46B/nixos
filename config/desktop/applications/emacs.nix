{ pkgs, functions, ... }:

functions.linkImpure "emacs" {
	hm.programs.emacs.enable = true;
	hm.home.packages = [ pkgs.texlive.combined.scheme-full ];
}
