inputs:

[
	inputs.nixmox.overlay
	inputs.nvim.overlays.default
	inputs.niri.overlays.niri
	inputs.f2k.overlays.window-managers
	inputs.copyparty.overlays.default

	(import ./derivations)
	(import ./overrides)
]
