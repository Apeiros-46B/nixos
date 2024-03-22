{ config, pkgs, ... }:

{
	imports = [
		./alacritty.nix
		./flameshot.nix
		./foot.nix
		./git.nix
		./zsh.nix
	];

	environment.systemPackages = with pkgs; [
		# files
		tree
		ripgrep
		inotify-tools
		zip
		unzip

		# misc
		fzf
		xdragon
		killall
		util-linux
		pciutils
	];
}
