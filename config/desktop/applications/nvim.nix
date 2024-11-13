{ lib, pkgs, functions, ... }:

functions.linkImpure "nvim" {
	programs.neovim = {
		enable = true;
		defaultEditor = true;
		vimAlias = false;
	};

	hm.home.packages = with pkgs; [
		xclip
		gcc
		gnumake
		nil # make nix language server available system-wide
	];

	environment.variables = {
		EDITOR = lib.mkForce "nvim";
		VISUAL = lib.mkForce "nvim";
	};
}
