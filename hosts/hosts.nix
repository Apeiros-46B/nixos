mkHost:

[
	(mkHost "atlas" {
		type = "desktop";
		theme = "everforest";
		system = "x86_64-linux";
		stateVersion = "23.11";
	})
	(mkHost "bastion" {
		type = "server";
		theme = "everforest";
		system = "x86_64-linux";
		stateVersion = "24.05";
	})
]
