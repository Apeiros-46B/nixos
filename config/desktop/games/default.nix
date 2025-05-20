{ pkgs, ... }:

{
	imports = [
		./minecraft.nix
		./steam.nix
		./util.nix
	];

	hm.home.packages = [ pkgs.mindustry-wayland ];
}
