{ pkgs, ... }:

{
	hm.home.packages = with pkgs; [ obs-studio ];
}
