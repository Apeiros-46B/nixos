{ ... }:

{
	imports = [
		./auth.nix
		./fs.nix
		./pipewire.nix
		./warp.nix
	];

	services.printing.enable = true;
	services.flatpak.enable = true;
	security.rtkit.enable = true;
}
