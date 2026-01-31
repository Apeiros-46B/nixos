{ pkgs, config, inputs, globals, ... }:

let
	port = 4000;
	domain = "box.${globals.net.pubDomain}";
	tsDomain = "box.${globals.net.tsDomain}";
	copypartyPython = pkgs.python313.withPackages (pypkgs: with pypkgs; [
		mutagen  # audio tagging
		pyvips   # image processing
		rawpy    # raw image support
	]);
in {
	imports = [
		inputs.copyparty.nixosModules.default
	];

	users = {
		users.copyparty = {
			isSystemUser = true;
			group = "nas";
		};
		groups.nas.members = [ "root" "copyparty" ];
	};

	environment.systemPackages = with pkgs; [ copyparty ];
	systemd.services.copyparty = {
		path = [ pkgs.ffmpeg-headless ];
		environment.PYTHONPATH = "${copypartyPython}/${copypartyPython.sitePackages}";
	};

	networking.firewall.allowedTCPPorts = [ port ];
	services.cloudflared.tunnels."72d0b7dc-fc9b-460e-9d70-c873c5e97fb8".ingress = {
		${domain} = "http://127.0.0.1:${toString port}";
	};
	services.nginx.virtualHosts.${tsDomain} = {
		useACMEHost = globals.net.tsDomain;
		forceSSL = true;
		locations."/" = {
			proxyPass = "http://127.0.0.1:${toString port}";
			proxyWebsockets = true;
			extraConfig = ''
				proxy_buffering off;
				client_max_body_size 0;
			'';
		};
	};

	sops.secrets.copyparty-inbox-password = {
		sopsFile = ./Secrets.yaml;
		owner = "copyparty";
		group = "nas";
		mode = "0400";
	};
	sops.secrets.copyparty-admin-password = {
		sopsFile = ./Secrets.yaml;
		owner = "copyparty";
		group = "nas";
		mode = "0400";
	};

	services.copyparty = {
		enable = true;
		user = "copyparty";
		group = "nas";
		settings = {
			no-reload = true;

			# connection
			i = "0.0.0.0";
			p = [ port ];
			rproxy = -1; # for cf tunnel
			http-only = true; # accessed through rproxy, they provide https
			site = "https://${domain}/";

			# security
			no-readme = true;
			no-logues = true; # TODO: figure out how to enable this only for inbox volume
			no-robots = true;
			usernames = true;
			ipr = "${globals.net.lanRange},${globals.net.tsRange}=admin";
			nih = true;
			xdev = true;
			xvol = true;

			# fs
			# no-clone = true; # TODO: figure out if we need this for syncthing compat?
			re-maxage = 60; # syncthing compat
			no-mtag-ff = true;
			shr = "/share";
			chmod-f = "660";
			chmod-d = "770";

			# LAN access
			z = true;
			z-on = [
				globals.net.lanRange
				globals.net.tsRange
			];
			# TODO: hooks to notify of uploads/downloads of large files over discord webhook

			# appearance
			og = true;
			og-ua = "(Discord|Twitter|Slack)bot";
			og-site = domain;
			theme = 3;
		};
		accounts = {
			inbox.passwordFile = "${config.sops.secrets.copyparty-inbox-password.path}";
			admin.passwordFile = "${config.sops.secrets.copyparty-admin-password.path}";
		};
		volumes = {
			"/inbox" = {
				path = "/nas/inbox";
				access = {
					wg = [ "inbox" ];
					A = [ "admin" ];
				};
				flags = {
					fk = 16;
					d2t = true;
					dthumb = true;
					nohtml = true;
					nodupe = true;
				};
			};
			"/music" = {
				path = "/nas/music";
				access = {
					g = [ "*" ];
					A = [ "admin" ];
				};
				flags = {
					# TODO: switch to dks/dky (? idk which one). also integrate with syncthing
					dk = 16;
					fk = 16;
					e2ts = true;
					e2dsa = true;
				};
			};
			"/private" = {
				path = "/nas/private";
				access = {
					A = [ "admin" ];
				};
				flags = {
					e2ts = true;
					e2dsa = true;
				};
			};
			"/public" = {
				path = "/nas/public";
				access = {
					r = "*";
					A = [ "admin" ];
				};
			};
		};
	};
}
