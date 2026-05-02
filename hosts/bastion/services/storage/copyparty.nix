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
	my.services.rproxy = {
		domains.${domain} = port;
		tsDomains.${tsDomain} = port;
	};

	sops.secrets.copyparty-inbox-password = {
		sopsFile = ./Secrets.yaml;
		owner = "copyparty";
		group = "nas";
		mode = "0400";
	};
	sops.secrets.copyparty-music-password = {
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
	sops.secrets.copyparty-joplin-password = {
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
			rproxy = 1; # frp setup
			xff-src = "127.0.0.1";
			xff-hdr = "x-real-ip";
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
			music.passwordFile = "${config.sops.secrets.copyparty-music-password.path}";
			admin.passwordFile = "${config.sops.secrets.copyparty-admin-password.path}";
			joplin.passwordFile = "${config.sops.secrets.copyparty-joplin-password.path}";
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
			"/music" = {
				path = "/nas/music";
				access = {
					g = [ "*" ];
					r = [ "music" ];
					A = [ "admin" ];
				};
				flags = {
					# TODO: switch to dks/dky (? idk which one)
					dk = 16;
					fk = 16;
					e2ts = true;
					e2dsa = true;
				};
			};
			"/joplin" = {
				path = "/nas/joplin";
				access = {
					A = [ "admin" "joplin" ];
				};
			};
		};
	};
}
