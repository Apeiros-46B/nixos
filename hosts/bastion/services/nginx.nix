{ config, ... }:

{
	networking.firewall.allowedTCPPorts = [ 80 443 ];

	# see https://nixos.wiki/wiki/Nginx#Hardened_setup_with_TLS_and_HSTS_preloading
	services.nginx = {
		enable = true;
		group = "acme";

		recommendedGzipSettings  = true;
		recommendedOptimisation  = true;
		recommendedProxySettings = true;
		recommendedTlsSettings   = true;

		# only allow PFS-enabled ciphers with AES256
		sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";

		appendHttpConfig = ''
			map $scheme $hsts_header {
					https  "max-age=31536000; includeSubdomains; preload";
			}
			add_header Strict-Transport-Security $hsts_header;
			#add_header Content-Security-Policy "script-src 'self'; object-src 'none'; base-uri 'none';" always;
			add_header 'Referrer-Policy' 'origin-when-cross-origin';
			add_header X-Frame-Options SAMEORIGIN;
			add_header X-Content-Type-Options nosniff;
			proxy_cookie_path / "/; secure; HttpOnly; SameSite=strict";
		'';

		virtualHosts =
			let
				dufsPort = toString (config.my.services.dufs.config.port or 5000);
			in
		{
			"box.apeiros.xyz" = {
				forceSSL = true;
				locations."/" = {
					proxyPass = "http://127.0.0.1:${dufsPort}/";
					proxyWebsockets = true;
					extraConfig = ''
						proxy_ssl_server_name on;
						proxy_pass_header Authorization;
					'';
				};
				sslCertificate = "/var/lib/acme/box.apeiros.xyz/cert.pem";
				sslCertificateKey = "/var/lib/acme/box.apeiros.xyz/key.pem";
			};
		};
	};
}
