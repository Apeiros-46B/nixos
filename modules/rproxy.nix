{ config, lib, globals, ... }:

let
	cfg = config.my.services.rproxy;
	mkLocation = port: {
		proxyPass = "http://127.0.0.1:${toString port}";
		proxyWebsockets = true;
		extraConfig = ''
			proxy_buffering off;
			client_max_body_size 0;
			proxy_set_header X-Real-IP $remote_addr;
			proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
		'';
	};
	frpProxyPort = 4443;
in {
	options.my.services.rproxy = with lib; {
		enable = mkEnableOption "rproxy";
		tokenPath = mkOption {
			type = types.str;
			description = "Path to a secret file containing the FRP client token.";
		};
		domains = mkOption {
			type = types.attrsOf types.port;
			default = {};
			description = "Map of domains to their backend ports (FRP PROXY protocol)";
		};
		tsDomains = mkOption {
			type = types.attrsOf types.port;
			default = {};
			description = "Map of Tailscale domains to their backend ports";
		};
		extraProxies = mkOption {
			type = types.attrsOf (types.submodule ({ name, config, ... }: {
				options = {
					name = lib.mkOption { type = types.str; default = name; };
					type = lib.mkOption { type = types.enum [ "tcp" "udp" ]; };
					localIP = lib.mkOption { type = types.str; default = "127.0.0.1"; };
					localPort = lib.mkOption { type = types.port; };
					remotePort = lib.mkOption { type = types.port; default = config.localPort; };
				};
			}));
			default = {};
			description = "Extra FRP proxies";
		};
	};

	config = lib.mkIf cfg.enable {
		networking.firewall.allowedTCPPorts = [ 80 443 ];

		# see https://nixos.wiki/wiki/Nginx#Hardened_setup_with_TLS_and_HSTS_preloading
		services.nginx = {
			enable = true;
			enableReload = true;

			recommendedGzipSettings  = true;
			recommendedOptimisation  = true;
			recommendedProxySettings = true;
			recommendedTlsSettings   = true;

			# only allow PFS-enabled ciphers with AES256
			sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";

			appendHttpConfig = ''
				set_real_ip_from 127.0.0.1;
				real_ip_header proxy_protocol;

				map $scheme $hsts_header {
					https "max-age=31536000; includeSubdomains; preload";
				}
				add_header Strict-Transport-Security $hsts_header;

				add_header 'Referrer-Policy' 'origin-when-cross-origin';
				add_header X-Frame-Options SAMEORIGIN;
				add_header X-Content-Type-Options nosniff;

				proxy_cookie_path / "/; secure; HttpOnly; SameSite=Lax";
			'';
		};

		services.nginx.virtualHosts =
			(lib.mapAttrs (domain: port: {
				useACMEHost = globals.net.pubDomain;
				forceSSL = true;
				listen = [
					{
						addr = "0.0.0.0";
						port = 443;
						ssl = true;
					}
					{
						addr = "127.0.0.1";
						port = frpProxyPort;
						ssl = true;
						extraParameters = [ "proxy_protocol" ];
					}
				];
				locations."/" = mkLocation port;
			}) cfg.domains)
			//
			(lib.mapAttrs (domain: port: {
				useACMEHost = globals.net.tsDomain;
				forceSSL = true;
				locations."/" = mkLocation port;
			}) cfg.tsDomains);

		systemd.services.frp-rproxy.serviceConfig.LoadCredential = [
			"frp-token:${cfg.tokenPath}"
		];

		services.frp.instances.rproxy = {
			enable = true;
			role = "client";
			settings = {
				serverAddr = globals.net.frpVpsIp;
				serverPort = 7000;

				auth.method = "token";
				auth.tokenSource = {
					type = "file";
					file.path = "/run/credentials/frp-rproxy.service/frp-token";
				};

				proxies = [
					{
						name = "nginx-http";
						type = "tcp";
						localIP = "127.0.0.1";
						localPort = 80;
						remotePort = 80;
					}
					{
						name = "nginx-https";
						type = "tcp";
						localIP = "127.0.0.1";
						localPort = frpProxyPort;
						remotePort = 443;
						transport.proxyProtocolVersion = "v2";
					}
				] ++ lib.attrValues cfg.extraProxies;
			};
		};
	};
}
