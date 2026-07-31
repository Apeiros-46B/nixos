{ pkgs, ... }:

{
	imports = [
		./minecraft.nix
		./steam.nix
		./util.nix
		./waydroid.nix
	];

	hm.home.packages = with pkgs; [
		#mindustry-wayland
		vintagestory
	];
}
