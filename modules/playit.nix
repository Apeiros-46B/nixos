{ config, lib, pkgs, ... }:

let
	cfg = config.my.services.playit;
	dataDir = "/var/lib/playit";
in {
	options.my.services.playit = with lib; {
		enable = mkEnableOption "playit, a tunneling service";
	};

	config = lib.mkIf cfg.enable {
		environment.systemPackages = [
 			(pkgs.writeShellScriptBin "playit" ''
				${pkgs.my.playit}/bin/playit --secret_path "${dataDir}/playit.toml" "$@"
			'')
		];
		systemd.tmpfiles.settings."10-my-playit".${dataDir}.d = {
			user = "root";
			group = "root";
			mode = "0700";
		};
	};
}
