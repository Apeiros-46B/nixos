{ system, overlays, ... }:

{
	imports = [
		./services
		./system
		./tools
	];

	nix.settings = {
		experimental-features = [ "nix-command" "flakes" ];
		substituters = [ "https://cuda-maintainers.cachix.org" ];
	};
	nixpkgs = {
		inherit overlays;
		config.allowUnfree = true;
		hostPlatform = system;
	};
	environment.variables.NIXPKGS_ALLOW_UNFREE = "1";
	programs.nix-ld.enable = true;
}
