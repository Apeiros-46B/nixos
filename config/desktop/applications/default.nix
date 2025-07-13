{ ... }:

{
	imports = [
		./creative.nix
		./emacs.nix
		./media.nix
		./nvim.nix
		./office.nix
		./social.nix
		./web.nix
	];

	# TODO: move elsewhere
	virtualisation.waydroid.enable = true;
}
