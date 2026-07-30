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
		restartUnits = [ "copyparty.service" ];
	};
	sops.secrets.copyparty-media-password = {
		sopsFile = ./Secrets.yaml;
		owner = "copyparty";
		group = "copyparty";
		mode = "0400";
		restartUnits = [ "copyparty.service" ];
	};
	sops.secrets.copyparty-admin-password = {
		sopsFile = ./Secrets.yaml;
		owner = "copyparty";
		group = "copyparty";
		mode = "0400";
		restartUnits = [ "copyparty.service" ];
	};

	services.copyparty = {
		enable = true;
		user = "copyparty";
		group = "copyparty";

		# lan or tailscale connections get lan pseudo-user,
		# localhost connections get lo pseudo-user
		globalExtraConfig = ''
			ipu: ${globals.net.lanRange}=lan
			ipu: ${globals.net.tsRange}=lan
			ipu: 127.0.0.1/32=lo
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

			# prometheus
			stats = true;
			e2dsa = true;
			nos-dup = true;

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
			lan.passwordFile = "${config.sops.secrets.copyparty-admin-password.path}";
			lo.passwordFile = "${config.sops.secrets.copyparty-admin-password.path}";
		};
		volumes = {
			"/media" = {
				path = "/mnt/media";
				access = {
					r = [ "lan" "media" ];
					A = [ "admin" ];
					a = [ "lo" ];
				};
				flags = {
					e2ts = true;
					opds = true;
					opds_exts = [];
					scan = 300; # syncthing, suwayomi, etc
				};
			};
			"/sync" = {
				path = "/mnt/nas/sync";
				access = {
					A = [ "admin" ];
					a = [ "lo" ];
				};
				flags = {
					e2ts = true;
					scan = 300;
					chmod_f = "0660";
					chmod_d = "0770";
				};
			};
			"/inbox" = {
				path = "/mnt/nas/inbox";
				access = {
					wg = [ "inbox" ];
					A = [ "admin" ];
					a = [ "lo" ];
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
					a = [ "lo" ];
				};
				flags = {
					e2ts = true;
				};
			};
			"/public" = {
				path = "/mnt/nas/public";
				access = {
					r = "*";
					A = [ "admin" ];
					a = [ "lo" ];
				};
			};
		};
	};

	services.prometheus.scrapeConfigs = [
		{
			job_name = "copyparty";
			metrics_path = "/.cpr/metrics";
			static_configs = [{
				targets = [ "localhost:${toString port}" ];
			}];
		}
	];
}
