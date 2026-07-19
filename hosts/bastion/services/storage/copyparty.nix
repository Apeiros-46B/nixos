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

	environment.systemPackages = [ pkgs.copyparty ];
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
		group = "copyparty";
		mode = "0400";
	};
	sops.secrets.copyparty-media-password = {
		sopsFile = ./Secrets.yaml;
		owner = "copyparty";
		group = "copyparty";
		mode = "0400";
	};
	sops.secrets.copyparty-admin-password = {
		sopsFile = ./Secrets.yaml;
		owner = "copyparty";
		group = "copyparty";
		mode = "0400";
	};

	services.copyparty = {
		enable = true;
		user = "copyparty";
		group = "copyparty";

		# lan or tailscale connections get "local" pseudo-user
		globalExtraConfig = ''
			ipu: ${globals.net.lanRange}=local
			ipu: ${globals.net.tsRange}=local
		'';

		settings = {
			no-reload = true;

			# connection
			i = "0.0.0.0";
			p = [ port ];
			rproxy = 1; # frp setup
			xff-src = "127.0.0.1";
			xff-hdr = "x-real-ip";
			http-only = true; # accessed through rproxy, it provides https
			site = "https://${domain}/";

			# security
			no-readme = true;
			no-robots = true;
			usernames = true;
			ipr = "${globals.net.lanRange},${globals.net.tsRange}=admin";
			nih = true;
			xdev = true;
			xvol = true;

			# fs
			no-mtag-ff = true;
			shr = "/share";
			chmod-f = "640";
			chmod-d = "750";

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
			media.passwordFile = "${config.sops.secrets.copyparty-media-password.path}";
			admin.passwordFile = "${config.sops.secrets.copyparty-admin-password.path}";
			local.passwordFile = "${config.sops.secrets.copyparty-admin-password.path}";
		};
		volumes = {
			"/inbox" = {
				path = "/mnt/nas/inbox";
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
					no_logues = true;
				};
			};
			"/private" = {
				path = "/mnt/nas/private";
				access = {
					A = [ "admin" ];
				};
				flags = {
					e2ts = true;
					e2dsa = true;
				};
			};
			"/public" = {
				path = "/mnt/nas/public";
				access = {
					r = "*";
					A = [ "admin" ];
				};
			};
			"/media" = {
				path = "/mnt/nas/media";
				access = {
					r = [ "local" "media" ];
					A = [ "admin" ];
				};
				flags = {
					e2ts = true;
					e2dsa = true;
					opds = true;
					opds_exts = [ "cbz" "cbr" "epub" "mobi" "pdf" ];
					scan = 300; # TODO: suwayomi
				};
			};
			"/music" = {
				path = "/mnt/nas/music";
				access = {
					r = [ "local" "media" ];
					A = [ "admin" ];
				};
				flags = {
					e2ts = true;
					e2dsa = true;
					scan = 300; # syncthing
				};
			};
		};
	};
}
