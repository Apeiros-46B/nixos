{ pkgs, ... }:

{
	imports = [
		./alacritty.nix
		./flameshot.nix
		./foot.nix
		./git.nix
		./st.nix
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
