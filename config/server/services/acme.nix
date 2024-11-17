{ config, ... }:

{
	sops.secrets.cloudflare-acme-tokens = {
		sopsFile = ./Secrets.yaml;
		owner = "root";
		group = "root";
		mode = "0400";
	};

	security.acme = {
		acceptTerms = true;
		defaults = {
			email = "apeiros46@gmail.com";
			dnsProvider = "cloudflare";
			environmentFile = config.sops.secrets.cloudflare-acme-tokens.path;
		};
		certs."img.apeiros.xyz" = {};
	};
}
