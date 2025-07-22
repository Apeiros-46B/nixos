{ pkgs, ... }:

{
	hm.home.packages = with pkgs; [
		aseprite
		darktable
		gimp3
		davinci-resolve
		godot
		blender
		# (blender.override {
		# 	cudaSupport = true;
		# })
	];
}
