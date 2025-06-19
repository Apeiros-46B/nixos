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
			gamemoderun gamescope -F nearest -S integer -o 30 -w 1888 -h 1084 -b --mangoapp "$@"
		'')
	];
}
