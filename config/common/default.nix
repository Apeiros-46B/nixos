{ system, overlays, ... }:

{
	imports = [
		./services
		./system
		./tools
	];

	nix.settings.experimental-features = [ "nix-command" "flakes" ];
	nixpkgs = {
		inherit overlays;
		config.allowUnfree = true;
		hostPlatform = system;
	};
	programs.nix-ld.enable = true;
}
