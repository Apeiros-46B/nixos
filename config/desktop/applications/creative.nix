{ pkgs, ... }:

{
	hm.home.packages = with pkgs; [
		aseprite
		darktable
		gimp3
		davinci-resolve
		godot
		(blender.override {
			cudaSupport = true;
		})
	];
}
