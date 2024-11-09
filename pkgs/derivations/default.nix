(final: _: {
	my.bitsnpicas = import ./bitsnpicas.nix { pkgs = final; };
	my.fairfax-font = import ./fairfax.nix { pkgs = final; };
	my.openmvide = import ./openmvide.nix { pkgs = final; };
	my.playit = import ./playit.nix { pkgs = final; };
})
