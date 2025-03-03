{ config, lib, pkgs, ... }:

let
	cfg = config.my.services.shimmie;
	defaultPort = 9000;
	varDir = "/var/lib/shimmie";
in
{
	options.my.services.shimmie = with lib; with lib.types; {
		enable = mkEnableOption "shimmie, a taggable image board (booru)";
		port = mkOption {
			type = int;
			default = defaultPort;
		};
		openFirewall = mkOption {
			type = bool;
			default = true;
		};
		config = mkOption {
			type = attrsOf anything;
			default = {};
		};
	};

	config = lib.mkIf cfg.enable {
		users.users.shimmie = {
			isSystemUser = true;
			packages = [ pkgs.my.shimmie ];
			group = "shimmie";
		};
		users.groups.shimmie = {};

		networking.firewall.allowedTCPPorts =
			lib.mkIf cfg.openFirewall [ (cfg.port or defaultPort) ];

		systemd.tmpfiles.settings = {
			"10-shimmie.log"."/var/log/shimmie.log".f = {
				user  = "shimmie";
				group = "shimmie";
				mode  = "0660";
			};
			"10-shimmie".${varDir}.d = {
				user  = "shimmie";
				group = "shimmie";
				mode  = "0770";
			};
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
					fail() {
						>&2 echo "$@"
						exit 1
					}
					data="./data"
					srv="./server"

					mkdir -p "$data" || fail "Failed making data folder"
					rm -rf "$srv" || fail "Failed rm old server files"

					# pull source code and composer packages
					cp -r --no-preserve=mode "${pkgs.my.shimmie}" "$srv" || fail "Failed pulling source"
					${pkgs.php83Packages.composer}/bin/composer install -d "$srv" || fail "Failed install php pkgs"

					# launch server
					cd "$srv"
					ln -s "../$data" "./data" || fail "Failed symlink server data"
					${pkgs.php}/bin/php -S 0.0.0.0:${toString cfg.port} tests/router.php
				''}/bin/shimmie-wrapper";
			};
		};
	};
}
