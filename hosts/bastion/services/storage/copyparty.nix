{ pkgs, config, inputs, ... }:

let
	port = 4000;
	domain = "box.apeiros.xyz";
	lanRange = "10.0.0.0/8";
	tailscaleRange = "100.64.0.0/10";
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
	systemd.services.copyparty.path = with pkgs; [
		python313Packages.paramiko # TODO: sftp, ftps, ftp, webdav? which one?
		python313Packages.mutagen
		python313Packages.pyvips
		python313Packages.rawpy
		ffmpeg-headless
	];

	networking.firewall.allowedTCPPorts = [ port ];
	services.cloudflared.tunnels."72d0b7dc-fc9b-460e-9d70-c873c5e97fb8".ingress = {
		${domain} = "http://localhost:${toString port}";
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
			xff-hdr = "cf-proxying-ip";

			# security
			no-readme = true;
			no-logues = true; # TODO: figure out how to enable this only for inbox volume
			no-robots = true;
			usernames = true;
			ipr = "${lanRange},${tailscaleRange}=admin";
			nih = true;
			xdev = true;
			xvol = true;

			# fs
			# no-clone = true; # TODO: figure out if we need this for syncthing compat?
			re-maxage = 60; # syncthing compat
			no-mtag-ff = true;

			# LAN access
			z = true;
			z-on = [ lanRange tailscaleRange ];
			# TODO: set it up over nginx so i can access `bastion.local` directly on 80/443
			# TODO: hooks to notify of uploads/downloads of large files over discord webhook

			# appearance
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
					wG = [ "inbox" ];
					A = [ "admin" ];
				};
				flags = {
					fk = 16;
					d2t = true;
					dthumb = true;
					nohtml = true;
				};
			};
			"/public" = {
				path = "/nas/public";
				access = {
					r = "*";
					A = [ "admin" ];
				};
				flags = {
					og = true;
				};
			};
			"/private" = {
				path = "/nas/private";
				access = {
					A = [ "admin" ];
				};
				flags = {
					e2dsa = true;
					e2ts = true;
				};
			};
		};
	};
}
