{ inputs, lib, pkgs, globals, ... }:

{
	imports = [
		inputs.home-manager.nixosModules.home-manager
		(lib.mkAliasOptionModule [ "hm" ] [ "home-manager" "users" globals.user ])
	];

	environment.systemPackages = [ pkgs.home-manager ];

	home-manager = {
		useGlobalPkgs = true;
		useUserPackages = true;
	};

	hm = {
		news = {
			display = "silent";
			json = lib.mkForce {};
			entries = lib.mkForce [];
		};
		home = {
			username = globals.user;
			homeDirectory = globals.home;
		};
		programs.home-manager.enable = true; # enable self-management
	};
}
