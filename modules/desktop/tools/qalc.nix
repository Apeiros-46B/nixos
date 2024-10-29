{ pkgs, ... }:

{
	hm.home.packages = with pkgs; [ libqalculate qalculate-gtk ];
}
