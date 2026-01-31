{ config, globals, ... }:

{
	sops.secrets.cloudflare-acme-tokens = {
		sopsFile = ./Secrets.yaml;
		owner = "acme";
		group = "acme";
		mode = "0400";
	};

	security.acme =
		let tsDomain = globals.net.tsDomain; in
	{
		acceptTerms = true;
		defaults.email = "apeiros46@gmail.com";

		# tailnet internal domain
		certs.${tsDomain} = {
			domain = tsDomain;
			extraDomainNames = [ "*.${tsDomain}" ];
			environmentFile = config.sops.secrets.cloudflare-acme-tokens.path;
			dnsProvider = "cloudflare";
			group = config.services.nginx.group;
		};
	};
}
