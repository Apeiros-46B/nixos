{ pkgs, ... }:

{
	imports = [
		./alacritty.nix
		./flameshot.nix
		./foot.nix
		./git.nix
		./shells.nix
		./st.nix
		./urxvt.nix
	];

	environment.systemPackages = with pkgs; [
		# files
		tree
		ripgrep
		inotify-tools
		zip
		unzip
		xdragon
		vimv

		# devices
		util-linux
		pciutils

		# misc
		fzf
		killall
	];
}
