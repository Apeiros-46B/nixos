{ config, pkgs, ... }:

{
	imports = [
		./minecraft.nix
		./steam.nix
	];

	my.home.packages = with pkgs; [
		mangohud
	];
}
