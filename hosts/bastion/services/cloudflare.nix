{ config, ... }:

{
	sops.secrets.cloudflare-tunnel-cert = {
		sopsFile = ./Secrets.yaml;
		owner = "root";
		group = "root";
		mode = "0400";
	};
	sops.secrets.cloudflare-copyparty-tunnel = {
		sopsFile = ./Secrets.yaml;
		owner = "root";
		group = "root";
		mode = "0400";
	};
	services.cloudflared = {
		enable = true;
		tunnels = {
			"2bc4f694-b757-4787-bb34-e2c753c3d748" =
				let
					copypartyPort = (builtins.elemAt config.services.copyparty.settings.p 0);
				in
			{
				certificateFile = config.sops.secrets.cloudflare-tunnel-cert.path;
				credentialsFile = config.sops.secrets.cloudflare-copyparty-tunnel.path;
				ingress = {
					"box.apeiros.xyz" = "http://localhost:${toString copypartyPort}";
					"service" = "http_status:404";
				};
				default = "http_status:404";
			};
		};
	};
}
