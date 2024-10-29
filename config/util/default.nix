{ inputs, hostname }:

rec {
	functions = import ./functions { inherit inputs globals; };
	globals   = import ./globals.nix hostname;
	overlays  = import ../../pkgs inputs;
}
