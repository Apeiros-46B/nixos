{ inputs, pkgs, ... }:

{
	imports = [
		inputs.septabee.nixosModules.default
	];

	hm.home.packages = with pkgs; [
		darktable

		gimp3
		davinci-resolve

		aseprite
		krita
		godot
		blender
	];

	programs.septabee = {
		enable = true;
		wayland-deps = true;
		version = "latest";
		offline = true;
	};
}
