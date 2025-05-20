(final: _: {
	my.playit       = import ./playit.nix     { pkgs = final; };
	my.shimmie      = import ./shimmie.nix    { pkgs = final; };
	my.openmvide    = import ./openmvide.nix  { pkgs = final; };
	my.bitsnpicas   = import ./bitsnpicas.nix { pkgs = final; };
})
