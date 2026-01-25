{ config, ... }:

{
	sops.secrets.cloudflare-tunnel-cert = {
		sopsFile = ./Secrets.yaml;
		owner = "root";
		group = "root";
		mode = "0400";
	};
	sops.secrets.cloudflare-tunnel-creds = {
		sopsFile = ./Secrets.yaml;
		owner = "root";
		group = "root";
		mode = "0400";
	};

	services.cloudflared = {
		enable = true;
		tunnels = {
			"72d0b7dc-fc9b-460e-9d70-c873c5e97fb8" = {
				certificateFile = config.sops.secrets.cloudflare-tunnel-cert.path;
				credentialsFile = config.sops.secrets.cloudflare-tunnel-creds.path;
				ingress."service" = "http_status:404";
				default = "http_status:404";
			};
		};
	};
}
