{ pkgs, config, inputs, ... }:

let
	port = 4000;
	domain = "box.apeiros.xyz";
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
	environment.systemPackages = [ pkgs.copyparty ];

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
	sops.secrets.copyparty-apeiros-password = {
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
			i = "0.0.0.0";
			p = [ port ];
			rproxy = -1;
			no-reload = true;
			usernames = true;
			xvol = true;
		};
		accounts = {
			inbox.passwordFile = "${config.sops.secrets.copyparty-inbox-password.path}";
			apeiros.passwordFile = "${config.sops.secrets.copyparty-apeiros-password.path}";
		};
		volumes = {
			"/inbox" = {
				path = "/nas/inbox";
				access = {
					wG = [ "inbox" ];
					A = [ "apeiros" ];
				};
				flags = {
					fk = 16;
					d2t = true;
					magic = true;
					norobots = true;
				};
			};
			"/public" = {
				path = "/nas/public";
				access = {
					r = "*";
					A = [ "apeiros" ];
				};
				flags = {
					magic = true;
					og = true;
					og_site = domain;
				};
			};
			"/private" = {
				path = "/nas/private";
				access = {
					A = [ "apeiros" ];
				};
				flags = {
					e2dsa = true;
					e2ts = true;
					magic = true;
					norobots = true;
				};
			};
		};
	};
}
