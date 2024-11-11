{ pkgs, ... }:

{
	imports = [
		./flameshot.nix
		./obs.nix
		./qalc.nix
		./screenkey.nix
		./st.nix
		./urxvt.nix
	];

	environment.systemPackages = with pkgs; [
		xdragon
	];
}
