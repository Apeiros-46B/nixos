inputs:

[
	inputs.nixmox.overlay
	inputs.nvim.overlays.default
	inputs.niri.overlays.niri
	inputs.f2k.overlays.window-managers

	(import ./derivations)
	(import ./overrides)
]
