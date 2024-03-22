{ config, pkgs, ... }:

{
	imports = [
		./brave.nix
		./emacs.nix
		./nvim.nix
		./sioyek.nix
	];
}
