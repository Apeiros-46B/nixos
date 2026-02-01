{ lib, pkgs, functions, ... }:

functions.linkImpure "nvim" {
	xdg.mime.defaultApplications = {
		"application/x-theme" = "nvim.desktop";
		"text/plain"          = "nvim.desktop";
		"text/xml"            = "nvim.desktop";
		"text/x-log"          = "nvim.desktop";
	};

	programs.neovim = {
		enable = true;
		defaultEditor = true;
		vimAlias = false;
	};

	hm.home.packages = with pkgs; [
		nil # make nix language server available system-wide
		gcc
		gnumake

		# qalc.nvim
		libqalculate
		qalculate-gtk
	];

	environment.variables = {
		EDITOR = lib.mkForce "nvim";
		VISUAL = lib.mkForce "nvim";
	};
}
