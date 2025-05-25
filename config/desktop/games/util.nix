{ pkgs, ... }:

{
	programs.gamemode = {
		enable = true;
		enableRenice = true;
		settings = {
			general = {
				renice = 10;
			};
			custom = {
				start = "${pkgs.libnotify}/bin/notify-send 'GameMode enabled'";
				end = "${pkgs.libnotify}/bin/notify-send 'GameMode disabled'";
			};
		};
	};

	hm.home.packages = with pkgs; [
		mangohud
		gamescope
		(pkgs.writeShellScriptBin "rungame" ''
			gamemoderun gamescope -F nearest -o 30 -b --mangoapp "$@"
		'')
		(pkgs.writeShellScriptBin "gamescope-4k" ''
			rungame -w 1920 -h 1080 -W 3840 -H 2160 "$@"
		'')
		(pkgs.writeShellScriptBin "gamescope-1080p" ''
			rungame -w 1920 -h 1080 -W 1920 -H 1080 "$@"
		'')
	];
}
