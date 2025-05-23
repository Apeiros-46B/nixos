{ inputs, hostname, type }:

rec {
	functions = import ./functions { inherit inputs globals; };
	globals   = import ./globals.nix { inherit hostname type; };
	overlays  = import ../../pkgs inputs;
}
