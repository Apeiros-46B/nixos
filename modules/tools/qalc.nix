{ pkgs, ... }:

{
	my.home.packages = with pkgs; [ libqalculate qalculate-gtk ];
}
