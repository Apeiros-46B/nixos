{ pkgs, ... }:

{
	hm.home.packages = with pkgs; [
		aseprite
		blender
		darktable
		gimp
	];
}
