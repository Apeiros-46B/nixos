# TODO: when to use inputs.*.follows?
{
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		sops-nix.url = "github:Mic92/sops-nix";
		nixvirt = {
			url = "https://flakehub.com/f/AshleyYakeley/NixVirt/*.tar.gz";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		nvim.url = "github:nix-community/neovim-nightly-overlay";
		niri.url = "github:sodiboo/niri-flake";
		f2k.url = "github:fortuneteller2k/nixpkgs-f2k";
		st.url = "github:Apeiros-46B/st";

		quickshell = {
			url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		qml-niri = {
			url = "github:imiric/qml-niri/main";
			inputs.nixpkgs.follows = "nixpkgs";
			inputs.quickshell.follows = "quickshell";
		};

		copyparty.url = "github:9001/copyparty";
		wawa.url = "github:amatgil/wawa";

		shimmie2.url = "github:Apeiros-46B/shimmie2";
		sidechain.url = "github:Apeiros-46B/sidechain";
		tspmo.url = "github:Apeiros-46B/tspmo";
	};

	outputs = inputs: (import ./hosts inputs);
}
