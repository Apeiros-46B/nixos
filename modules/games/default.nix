{ pkgs, ... }:

{
	imports = [
		./minecraft.nix
		./steam.nix
	];

	hm.home.packages = with pkgs; [
		mangohud
	];
}
