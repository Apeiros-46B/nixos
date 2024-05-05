{ pkgs, ... }:

{
	imports = [
		./applications
		./environment
		./games
		./graphical
		./tools
		./services
		./system
	];

	programs.nix-ld.enable = true;

	environment.systemPackages = [ pkgs.home-manager ];
}
