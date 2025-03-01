{
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		sops-nix.url = "github:Mic92/sops-nix";
		nixmox.url = "github:Sorixelle/nixmox";
		wawa.url = "github:amatgil/wawa";

		emacs.url = "github:nix-community/emacs-overlay";
		nvim.url = "github:nix-community/neovim-nightly-overlay";
		niri.url = "github:sodiboo/niri-flake";
		f2k.url = "github:fortuneteller2k/nixpkgs-f2k";
		st.url = "github:Apeiros-46B/st";
	};

	outputs = inputs: (import ./hosts inputs);
}
