{ config, pkgs, ... }:

{
	my.home.packages = with pkgs; [
		zulu17
		ferium
		prismlauncher
		fabric-installer
	];
}
