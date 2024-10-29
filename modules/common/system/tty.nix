{ config, lib, pkgs, functions, theme, ... }:

let
	colors = lib.concatStrings (lib.mapAttrsToList
		(k: v: "[2J[H]${k}${v}")
	{
		# {{{ theme the tty
		P0 = theme.colors.bg1;
		P8 = theme.colors.bg3;
		P1 = theme.colors.red;
		P9 = theme.colors.red;
		P2 = theme.colors.green;
		PA = theme.colors.green;
		P3 = theme.colors.yellow;
		PB = theme.colors.yellow;
		P4 = theme.colors.blue;
		PC = theme.colors.blue;
		P5 = theme.colors.purple;
		PD = theme.colors.purple;
		P6 = theme.colors.cyan;
		PE = theme.colors.cyan;
		P7 = theme.colors.fg1;
		PF = theme.colors.fg1;
		# }}}
	});
in {
	console = {
		font = "ter-i32b";
		packages = with pkgs; [ terminus_font ];
		useXkbConfig = true;
	};

	# black NixOS text on green background
	services.getty.greetingLine =
		''[1m[42;30m NixOS [0m \l'';

	environment.etc.issue.source = pkgs.writeText "issue" (functions.stripTabs ''
		${colors}${config.services.getty.greetingLine}

	'');
}
