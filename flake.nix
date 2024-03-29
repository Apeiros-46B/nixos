{
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		nvim.url = "github:nix-community/neovim-nightly-overlay";
		f2k.url = "github:fortuneteller2k/nixpkgs-f2k";
	};

	outputs = { self, nixpkgs, home-manager, ... }@inputs:
		let
			system = "x86_64-linux";
			pkgs = nixpkgs.legacyPackages.${system};
			util = import ./util { inherit inputs system; };
		in rec {
			nixosConfigurations = {
				atlas = util.mkHost {
					name = "atlas";
					stateVersion = "23.11"; # don't touch
					theme = import ./theme/everforest.nix;
					hostDefinition = ./hosts/atlas;
				};
			};

			homeConfigurations.atlas = nixosConfigurations.atlas.config.my.home;
		};
}
