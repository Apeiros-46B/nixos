{ pkgs, ... }:

{
	imports = [
		./services
		./system
		./tools
	];

	programs.nix-ld.enable = true;
	environment.systemPackages = [ pkgs.home-manager ];
}
