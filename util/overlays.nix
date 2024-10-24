# return a list of overlays given flake inputs
{ inputs }:

[
	# 3rd-party overlays
	inputs.nvim.overlays.default
	inputs.f2k.overlays.window-managers

	# my overrides
	(_: prev: {
		tewi-font = import ./pkgs/tewi.nix { pkgs = prev; };
	})

	# my packages
	(final: _: {
		my.openmvide = import ./pkgs/openmvide.nix { pkgs = final; };
	})
]
