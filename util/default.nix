{ inputs, system }:

rec {
	functions = import ./functions { inherit inputs globals; };
	globals = import ./globals.nix;
	overlays = import ./overlays.nix { inherit inputs; };

	mkHost = { name, stateVersion, theme, hostDefinition }:
		import ./host.nix {
			inherit name
							inputs
							system
							overlays
							functions
							globals
							theme
							stateVersion
							hostDefinition;
		};
}
