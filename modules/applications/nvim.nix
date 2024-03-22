{ config, pkgs, globals, functions, ... }:

functions.linkDots "nvim" {
	programs.neovim = {
		enable = true;
		defaultEditor = true;
		vimAlias = true;
	};

	my.home.packages = with pkgs; [
		xclip
		gcc
		gnumake
	];
}
