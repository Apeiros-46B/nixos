{ config, lib, pkgs, globals, ... }:

let
	httpPort = 5000;
	p2pPort = 8776;
	httpDomain = "git.${globals.net.pubDomain}";
	p2pDomain = "rad.${globals.net.pubDomain}";
	customRadicleExplorer = pkgs.radicle-explorer.withConfig {
		nodes = {
			fallbackPublicExplorer = "https://app.radicle.xyz/nodes/$host/$rid$path";
			requiredApiVersion = "~0.18.0";
			defaultHttpdScheme = "https";
			defaultHttpdPort = 443;
			defaultLocalHttpdPort = httpPort;
		};
		source = {
			commitsPerPage = 30;
		};
		supportWebsite = "https://radicle.zulipchat.com";
		deploymentId = null;
		preferredSeeds = [
			{
				scheme = "https";
				hostname = httpDomain;
				port = 443;
			}
		];
	};
in {
	my.services.rproxy.domains.${httpDomain} = httpPort;
	services.nginx.virtualHosts.${httpDomain}.locations = {
		# override settings from rproxy module to serve explorer
		"/" = lib.mkForce {
			root = "${customRadicleExplorer}";
			tryFiles = "$uri $uri/ /index.html";
		};
		"/api" = {
			proxyPass = "http://127.0.0.1:${toString httpPort}";
		};
		"= /node" = {
			proxyPass = "http://127.0.0.1:${toString httpPort}";
		};
	};

	# expose p2p through frp
	services.frp.settings.proxies = [
		{
			name = "radicle-p2p";
			type = "tcp";
			localIP = "127.0.0.1";
			localPort = p2pPort;
			remotePort = p2pPort;
		}
	];

	sops.secrets.radicle-private-key = {
		sopsFile = ./Secrets.yaml;
		owner = "radicle";
		group = "radicle";
		mode = "0400";
		restartUnits = [ "radicle-node.service" ];
	};

	services.radicle = {
		enable = true;
		privateKeyFile = config.sops.secrets.radicle-private-key.path;
		publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEYGJAJPAf0szS1msGxfqwov0lAF9n+gazo/iiJ3qeAa radicle";

		node.openFirewall = true;

		httpd = {
			enable = true;
			listenAddress = "127.0.0.1";
			listenPort = httpPort;
		};

		settings = {
			publicExplorer = "https://${httpDomain}";
			node = {
				alias = p2pDomain;
				listen = [ "0.0.0.0:${toString p2pPort}" ];
				externalAddresses = [
					"${p2pDomain}:${toString p2pPort}"
					"${globals.net.frpVpsIp}:${toString p2pPort}"
				];

				seedingPolicy = {
					default = "block";
				};

				targetOutboundPeers = 8;
				maxInboundPeers = 32;
			};
			web = {
				pinned = {
					repositories = [
						"rad:z2F1fxgvjUnHooB4tJjLa9UCUWiPN" # lwk
					];
				};
			};
		};
	};
}
