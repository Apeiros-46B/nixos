mkHost:

[
	(mkHost "acropolis" {
		type = "desktop";
		theme = "everforest";
		system = "x86_64-linux";
		stateVersion = "24.05";
		globals = {};
	})
	(mkHost "atlas" {
		type = "desktop";
		theme = "elysium";
		system = "x86_64-linux";
		stateVersion = "23.11";
		globals = {};
	})
	(mkHost "bastion" {
		type = "server";
		theme = "everforest";
		system = "x86_64-linux";
		stateVersion = "24.05";
		globals.dir.nix = "/etc/nixos";
	})
]
