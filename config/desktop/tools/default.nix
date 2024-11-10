{ pkgs, ... }:

{
	imports = [
		./flameshot.nix
		./obs.nix
		./qalc.nix
		./st.nix
		./urxvt.nix
	];

	environment.systemPackages = with pkgs; [
		xdragon
	];
}
