{ pkgs, config, inputs, ... }:

let
	copypartyPort = 4000;
in {
	imports = [
		inputs.copyparty.nixosModules.default
	];

	#	set up users
	users = {
		users.samba = {
			isSystemUser = true;
			group = "nas";
		};
		users.copyparty = {
			isSystemUser = true;
			group = "nas";
		};
		groups.nas.members = [ "root" "copyparty" "samba" "dufs" ];
	};

	environment.systemPackages = [ pkgs.copyparty ];

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

	networking.firewall.allowedTCPPorts = [ copypartyPort ];
	services.copyparty = {
		enable = true;
		user = "copyparty";
		group = "nas";
		settings = {
			i = "0.0.0.0";
			p = [ copypartyPort ];
			no-reload = true;
			usernames = true;
			rproxy = -1;
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
					og_site = "box.apeiros.xyz";
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
	
	# {{{ set up directories and symlinks
	systemd.tmpfiles.settings."10-nas" = {
		"/nas".d = {
			user = "root";
			group = "nas";
			mode = "0770";
		};

		# copyparty
		"/nas/inbox".d = {
			user = "copyparty";
			group = "nas";
			mode = "0750";
		};
		"/nas/public".d = {
			user = "copyparty";
			group = "nas";
			mode = "0750";
		};
		"/nas/private".d = {
			user = "copyparty";
			group = "nas";
			mode = "0750";
		};

		"/nas/samba".d = {
			user = "samba";
			group = "nas";
			mode = "0770";
		};

		# only accessible via samba
		"/nas/samba/priv".d = {
			user = "samba";
			group = "nas";
			mode = "0750";
		};
		# accessible via samba, read-write in dufs (password protected)
		"/nas/samba/prot".d = {
			user = "samba";
			group = "nas";
			mode = "0770";
		};
		# accessible via samba, read-only in dufs (not protected)
		"/nas/samba/pub".d = {
			user = "samba";
			group = "nas";
			mode = "0770";
		};
		# accessible via samba, read-write in dufs (password protected)
		"/nas/samba/inbox".d = {
			user = "samba";
			group = "nas";
			mode = "0770";
		};

		# dufs links
		"/nas/dufs".d = {
			user = "dufs";
			group = "nas";
			mode = "0550";
		};
		"/nas/dufs/inbox"."L+".argument   = "/nas/samba/inbox";
		"/nas/dufs/public"."L+".argument  = "/nas/samba/pub";
		"/nas/dufs/private"."L+".argument = "/nas/samba/prot";
	};
	# }}}
	
	# {{{ samba for local management and transfers
	services.samba = {
	# enable = true;
	# openFirewall = true;
	# settings = {
	# 	global = {
	# 		"workgroup" = "WORKGROUP";
	# 		"server string" = "smbnix";
	# 		"netbios name" = "smbnix";
	# 		"security" = "user";
	# 		"hosts allow" = "192.168.0. 127.0.0.1 localhost";
	# 		"hosts deny" = "0.0.0.0/0";
	# 		"guest account" = "nobody";
	# 		"map to guest" = "bad user";
	# 	};
	# 	inbox = {
	# 		"path" = "/nas/samba/inbox";
	# 		"browseable" = "yes";
	# 		"read only" = "no";
	# 		"guest ok" = "yes";
	# 	};
	# 	pub = {
	# 		"path" = "/nas/samba/pub";
	# 	};
	# 	prot = {
	# 		"path" = "/nas/samba/prot";
	# 		"browseable" = "yes";
	# 		"read only" = "no";
	# 		"create mask" = "0644";
	# 		"directory mask" = "0755";
	# 		"force user"
	# 	};
	# 	priv = {
	# 		"path" = "/nas/samba/priv";
	# 	};
	# };
	};
	# }}}

	# {{{ dufs for basic access over the internet
	# this cert is used by nginx, not here
	security.acme.certs."box.apeiros.xyz" = {};
	sops.secrets.dufs-auth-env = {
		sopsFile = ./Secrets.yaml;
		owner = "dufs";
		group = "dufs";
		mode = "0400";
		restartUnits = [ "dufs.service" ];
	};
	my.services.dufs = {
		enable = true;
		openFirewall = true;
		group = "nas";
		authEnvFile = config.sops.secrets.dufs-auth-env.path;
		config = {
			port = 5000;
			serve-path = "/nas/dufs";
			log-file = "/var/log/dufs.log";
			compress = "medium";
	
			allow-all = false;
			allow-upload = true;
			allow-delete = false;
			allow-search = true;
			allow-symlink = true;
			allow-archive = true;
	
			render-index = false;
			render-try-index = false;
			render-spa = false;
	
			enable-cors = true;
		};
	};
	# }}}
}
