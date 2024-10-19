{ pkgs, ... }:

{
	environment.systemPackages = with pkgs; [
		inotify-tools
		tree
		zip
		unzip
		xdragon

		vimv
		fzf
		ripgrep

		util-linux
		pciutils

		killall
		btop
	];
}
