{ ... }:

{
	imports = [
		./auth.nix
		./pipewire.nix
		./warp.nix
	];

	services.printing.enable = true;
	security.rtkit.enable = true;
}
