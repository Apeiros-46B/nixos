{ pkgs, ... }:

{
	imports = [
		./brave.nix
		./discord.nix
		./emacs.nix
		./nvim.nix
		./sioyek.nix
	];

	my.home.packages = with pkgs; [ mpv openmvide ];
	services.udev.packages = [ pkgs.openmvide ];
}
