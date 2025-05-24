{ ... }:

{
	imports = [
		./creative.nix
		./emacs.nix
		./media.nix
		./nvim.nix
		./office.nix
		./web.nix
	];

	# TODO: move elsewhere
	virtualisation.waydroid.enable = true;
}
