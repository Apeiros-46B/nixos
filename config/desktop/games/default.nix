{ pkgs, ... }:

{
	imports = [
		./minecraft.nix
		./steam.nix
		./util.nix
		./waydroid.nix
	];

	hm.home.packages = [ pkgs.mindustry-wayland ];
}
