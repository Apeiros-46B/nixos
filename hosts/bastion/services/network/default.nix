{ config, ... }:

{
	imports = [
		./tailscale.nix
		./pihole.nix
	];

	sops.secrets.frp-token = {
		sopsFile = ./Secrets.yaml;
		owner = "root";
		group = "root";
		mode = "0400";
	};

	my.services.rproxy = {
		enable = true;
		tokenPath = config.sops.secrets.frp-token.path;
	};
}
