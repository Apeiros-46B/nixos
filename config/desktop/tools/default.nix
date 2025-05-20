{ pkgs, ... }:

{
	imports = [
		./filemgr.nix
		./screencap.nix
		./terminals.nix
	];

	hm.home.packages = with pkgs; [
		xdragon
		libqalculate
		qalculate-gtk
	];
}
