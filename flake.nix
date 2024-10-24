{
	inputs = {
		# base
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		sops-nix.url = "github:Mic92/sops-nix";

		# overlays
		nvim.url = "github:nix-community/neovim-nightly-overlay";
		f2k.url = "github:fortuneteller2k/nixpkgs-f2k";

		# other
		st.url = "github:Apeiros-46B/st"; # fork from siduck's st
	};

	outputs = { self, nixpkgs, home-manager, ... }@inputs:
		let
			system = "x86_64-linux";
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

			homeConfigurations.atlas = nixosConfigurations.atlas.config.hm.home;
		};
}
