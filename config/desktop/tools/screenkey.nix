{ pkgs, theme, ... }:

{
	hm.home.packages = [
		(pkgs.writeShellScriptBin "screenkey" ''
			${pkgs.screenkey}/bin/screenkey \
				--window --timeout 3 --bak-mode normal --mods-mode win \
				--opacity 1.0 --font 'IBM Plex Sans' --font-size small \
				--font-color '#${theme.colors.fg2}' --bg-color '#${theme.colors.bg1}'
		'')
	];
}
