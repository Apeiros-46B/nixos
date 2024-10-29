{ pkgs, ... }:

{
	imports = [
		./flameshot.nix
		./qalc.nix
		./st.nix
		./urxvt.nix
	];

	environment.systemPackages = with pkgs; [
		xdragon
	];
}
