{ pkgs, functions, ... }:

functions.linkDots "nvim" {
	programs.neovim = {
		enable = true;
		defaultEditor = true;
		vimAlias = false;
	};

	my.home.packages = with pkgs; [
		xclip
		gcc
		gnumake
		nil # make nix language server available system-wide
	];
}
