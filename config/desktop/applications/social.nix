{ pkgs, ... }:

{
	hm.home.packages = with pkgs; [
		vesktop
		signal-cli
		signal-desktop
	];
}
