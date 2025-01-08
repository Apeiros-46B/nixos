{ pkgs, theme, ... }:

{
	fonts = {
		packages = with pkgs; [
			# Microsoft fonts
			corefonts
			ibm-plex
			twitter-color-emoji

			nerd-fonts.jetbrains-mono
			nerd-fonts.iosevka
			nerd-fonts.dejavu-sans-mono

			# my.fairfax-font # TODO: currently doesn't build
			tewi-font
			uiua386
		];

		fontDir.enable = true;
		fontconfig = {
			allowBitmaps = true;
			useEmbeddedBitmaps = true;
			defaultFonts = {
				serif     = [ theme.font.serif      ];
				sansSerif = [ theme.font.sans       ];
				monospace = [ theme.font.mono       ];
				emoji     = [ "Twitter Color Emoji" ];
			};
		};
	};
}
