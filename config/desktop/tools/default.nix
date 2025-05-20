{ inputs, pkgs, system, ... }:

{
	imports = [
		./flameshot.nix
		./foot.nix
		./urxvt.nix
	];

	hm.home.packages = with pkgs; [
		xdragon
		libqalculate
		qalculate-gtk
		obs-studio
		inputs.st.packages.${system}.st-snazzy
	];
}
