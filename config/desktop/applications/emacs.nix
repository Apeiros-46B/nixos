{ pkgs, functions, ... }:

functions.linkImpure "emacs" {
	hm.programs.emacs = {
		enable = true;
		package = pkgs.emacs-pgtk;
	};
	hm.home.packages = [ pkgs.texlive.combined.scheme-full ];
}
