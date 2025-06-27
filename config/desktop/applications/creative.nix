{ pkgs, ... }:

{
	hm.home.packages = with pkgs; [
		aseprite
		darktable
		gimp3
		blender
		# (blender.override {
		# 	cudaSupport = true;
		# })
	];
}
