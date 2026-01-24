{ pkgs, system, overlays, ... }:

{
	imports = [
		./services
		./system
		./tools
	];

	nix.settings = {
		experimental-features = [ "nix-command" "flakes" ];
		substituters = [ "https://nix-community.cachix.org" ];
		trusted-public-keys = [
			"nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
		];
	};
	nixpkgs = {
		inherit overlays;
		config.allowUnfree = true;
		hostPlatform = system;
	};
	environment.variables.NIXPKGS_ALLOW_UNFREE = "1";

	programs.nix-ld = {
		enable = true;
		libraries = with pkgs; [
			stdenv.cc.cc.lib
			zlib
		];
	};
	services.envfs.enable = true;
}
