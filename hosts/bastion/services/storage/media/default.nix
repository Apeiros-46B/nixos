{ inputs, config, globals, ... }:

{
	imports = [
		inputs.nixarr.nixosModules.default

		./download.nix
		./navidrome.nix
		./wg-patch.nix
	];

	sops.secrets.wireguard-config = {
		sopsFile = ./Secrets.yaml;
		owner = "root";
		group = "root";
		mode = "0400";
	};

	# uses the same media group already configured by storage/default.nix
	nixarr = {
		enable = true;
		mediaDir = "/mnt/media";
		stateDir = "/var/lib/nixarr";

		exporters.enable = true;
		vpn = {
			enable = true;
			exposeOnLAN = false; # prevent duplicate
			accessibleFrom = [
				globals.net.lanRange
				globals.net.tsRange
			];
			wgConf = config.sops.secrets.wireguard-config.path;
		};
	};
}
