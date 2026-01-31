{ config, lib, pkgs, ... }:

let
	cfg = config.my.services.shimmie;
	varDir = "/var/lib/shimmie";
	logFile = "/var/log/shimmie.log";
in
{
	options.my.services.shimmie = with lib; with lib.types; {
		enable = mkEnableOption "shimmie, a taggable image board (booru)";
		dataDir = mkOption {
			type = str;
			default = "/srv/shimmie";
		};
		port = mkOption {
			type = int;
			default = 9000;
		};
		openFirewall = mkOption {
			type = bool;
			default = true;
		};
		nginx.virtualHost = mkOption {
			type = str;
		};
		nginx.acmeHost = mkOption {
			type = str;
		};
	};

	config = lib.mkIf cfg.enable {
		users.users.shimmie = {
			isSystemUser = true;
			packages = [ pkgs.my.shimmie ];
			group = "shimmie";
		};
		users.groups.shimmie.members = [ "nginx" ];

		networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];

		systemd.tmpfiles.settings."10-shimmie" = {
			${logFile}.f = {
				user  = "shimmie";
				group = "shimmie";
				mode  = "0660";
			};
			${varDir}.d = {
				user  = "shimmie";
				group = "shimmie";
				mode  = "0770";
			};
			${cfg.dataDir}.d = {
				user  = "shimmie";
				group = "shimmie";
				mode  = "0770";
			};
			# fixes static serving
			"${cfg.dataDir}/data"."L+".argument = "${cfg.dataDir}";
		};

		services.nginx.virtualHosts."${cfg.nginx.virtualHost}" = {
			forceSSL = true;
			useACMEHost = cfg.nginx.acmeHost;
			root = cfg.dataDir;

			# serve static assets from disk
			locations."~ \"^/_images/([0-9a-f]{2})([0-9a-f]{30}).*$\"" = {
				priority = 1;
				alias = "${cfg.dataDir}/images/$1/$1$2";
				extraConfig = "expires 30d;";
			};
			locations."~ \"^/_thumbs/([0-9a-f]{2})([0-9a-f]{30}).*$\"" = {
				priority = 2;
				alias = "${cfg.dataDir}/thumbs/$1/$1$2";
				extraConfig = "expires 30d;";
			};
			locations."~ \"^.*\\.(css|js|map|gif|png|jpg|jpeg|ico|mp4|mov|mkv|webm|webp)$\"" = {
				priority = 3;
				tryFiles = "$uri /";
				extraConfig = "expires 1d;";
			};

			# pass other requests to shimmie
			locations."/" = {
				proxyPass = "http://127.0.0.1:${toString cfg.port}/";
				proxyWebsockets = true;
				# TODO: pass the original addr to shimmie using X-Real-IP
				extraConfig = ''
					proxy_ssl_server_name on;
					proxy_pass_header Authorization;
				'';
			};
		};

		services.postgresql = {
			ensureDatabases = [ "shimmie" ];
			ensureUsers = [
				{
					name = "shimmie";
					ensureDBOwnership = true;
				}
			];
			authentication = ''
				local  shimmie  shimmie                trust
				host   shimmie  shimmie  127.0.0.1/32  trust
				host   shimmie  shimmie  ::1/128       trust
			'';
		};

		systemd.services.shimmie = {
			description = "Start shimmie";
			wantedBy = [ "multi-user.target" ];
			wants = [ "network-online.target" ];
			after = [ "network-online.target" ];

			# prevent composer from trying to cache things in /var/empty
			environment.COMPOSER_HOME = "${varDir}/.composer";

			serviceConfig = {
				Type = "simple";
				User = "shimmie";
				Group = "shimmie";
				WorkingDirectory = varDir;
				ExecStart = "${pkgs.writeShellScriptBin "shimmie-wrapper" ''
					guard() {
						msg="$1"; shift
						"$@" || { >&2 echo "Failed at: $msg"; exit 1; }
					}

					# TODO: do a check to see if versions have been updated.
					# only pull source code if is a version mismatch between the nix store package and the "vendored" package

					# pull source code and composer packages
					guard "rm old server" rm -rf ./server
					guard "pull src" cp -r --no-preserve=mode "${pkgs.my.shimmie}" ./server
					guard "pull pkgs" ${pkgs.php83Packages.composer}/bin/composer install -d ./server
					guard "link data" ln -s "${cfg.dataDir}" ./server/data

					# launch server
					guard "cd to server" cd ./server || fail "Failed cd to server files"
					exec ${pkgs.php}/bin/php -S 0.0.0.0:${toString cfg.port} tests/router.php > "${logFile}" 2>&1
				''}/bin/shimmie-wrapper";
			};
		};
	};
}
