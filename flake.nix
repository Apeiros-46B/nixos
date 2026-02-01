{
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		sops-nix.url = "github:Mic92/sops-nix";
		nixmox.url = "git+https://git.isincredibly.gay/srxl/nixmox.git";
		nixvirt = {
			url = "https://flakehub.com/f/AshleyYakeley/NixVirt/*.tar.gz";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		nvim.url = "github:nix-community/neovim-nightly-overlay";
		niri.url = "github:sodiboo/niri-flake";
		f2k.url = "github:fortuneteller2k/nixpkgs-f2k";
		st.url = "github:Apeiros-46B/st";

		sidechain.url = "github:Apeiros-46B/sidechain";
		copyparty.url = "github:9001/copyparty";
		wawa.url = "github:amatgil/wawa";
	};

	outputs = inputs: (import ./hosts inputs);
}
