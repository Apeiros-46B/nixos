# return a list of overlays given flake inputs
{ inputs }:

[
	inputs.nvim.overlay
	inputs.f2k.overlays.window-managers
]
