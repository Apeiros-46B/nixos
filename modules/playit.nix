{ config, lib, pkgs, ... }:

let
	cfg = config.my.services.playit;
	dataDir = "/var/lib/playit";
	wrapped = (pkgs.writeShellScriptBin "playit" ''
		${pkgs.my.playit}/bin/playit --secret_path "${dataDir}/playit.toml" "$@"
	'');
in {
	options.my.services.playit = with lib; {
		enable = mkEnableOption "playit, a tunneling service";
	};

	config = lib.mkIf cfg.enable {
		environment.systemPackages = [
		];
		systemd.tmpfiles.settings."10-playit".${dataDir}.d = {
			user = "root";
			group = "root";
			mode = "0700";
		};
		systemd.services.playit = {
			description = "playit.gg agent";
			wantedBy    = [ "multi-user.target" ];
			wants       = [ "network-online.target" ];
			after       = [ "network-online.target" ];

			serviceConfig = {
				ExecStart = "${wrapped}/bin/playit -l /var/log/private/playit.log start";
				Restart = "on-failure";
			};
		};
	};
}
