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
		(pkgs.writeShellScriptBin "gamescope-4k" ''
			gamemoderun gamescope -w 1920 -h 1080 -W 3840 -H 2160 -o 30 -b -- "$@"
		'')
		(pkgs.writeShellScriptBin "gamescope-1080p" ''
			gamemoderun gamescope -w 1920 -h 1080 -W 1920 -H 1080 -o 30 -b -- "$@"
		'')
	];
}
