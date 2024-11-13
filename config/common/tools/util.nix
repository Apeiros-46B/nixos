{ pkgs, ... }:

{
	environment.systemPackages = with pkgs; [
		vimv
		file
		tree
		zip
		unzip

		killall
		btop

		util-linux
		pciutils
		inotify-tools
	];
}
