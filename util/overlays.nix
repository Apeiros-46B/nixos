# return a list of overlays given flake inputs
{ inputs }:

[
	inputs.nvim.overlays.default
	inputs.f2k.overlays.window-managers
	(_: prev: {
		tewi-font = import ./pkgs/tewi.nix { pkgs = prev; };
	})
	(final: _: {
		openmvide = import ./pkgs/openmvide.nix { pkgs = final; };
	})
]
