{ pkgs, ... }:

{
	hm.home.packages = with pkgs; [
		aseprite
		darktable
		gimp3
		blender
		godot
		# (blender.override {
		# 	cudaSupport = true;
		# })
	];
}
