{ pkgs, ... }:

{
	imports = [
		./filemgr.nix
		./screencap.nix
		./terminals.nix
		./vial.nix
	];

	hm.home.packages = with pkgs; [
		dragon-drop
		libqalculate
		qalculate-gtk
	];
}
