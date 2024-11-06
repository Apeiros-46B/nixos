{
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		sops-nix.url = "github:Mic92/sops-nix";
		nixmox.url = "github:Sorixelle/nixmox";

		nvim.url = "github:nix-community/neovim-nightly-overlay";
		f2k.url = "github:fortuneteller2k/nixpkgs-f2k";
		st.url = "github:Apeiros-46B/st";
	};

	outputs = { ... }@inputs: (import ./hosts inputs);
}
