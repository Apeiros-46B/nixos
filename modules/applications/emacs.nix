{ config, pkgs, globals, functions, ... }:

functions.linkDots "emacs" {
	my.programs.emacs.enable = true;
}
