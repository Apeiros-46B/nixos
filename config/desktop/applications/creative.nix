{ inputs, pkgs, ... }:

{
	imports = [
		inputs.septabee.nixosModules.default
	];

	hm.home.packages = with pkgs; [
		aseprite
		darktable
		gimp3
		davinci-resolve
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
