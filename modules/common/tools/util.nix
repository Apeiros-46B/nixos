{ pkgs, ... }:

{
	environment.systemPackages = with pkgs; [
		# files
		file
		tree
		zip
		unzip
		inotify-tools

		# process
		killall
		btop

		# interactive
		vim
		vimv
		ripgrep
		fzf # TODO: move to separate file

		# misc
		util-linux
		pciutils
	];
}
