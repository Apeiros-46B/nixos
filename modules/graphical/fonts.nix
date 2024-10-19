{ pkgs, theme, ... }:

{
	fonts = {
		packages = with pkgs; [
			# Microsoft fonts
			corefonts

			# JetBrainsMono Nerd Font
			(nerdfonts.override {
				fonts = [
					"JetBrainsMono"
					"Iosevka"
					"DejaVuSansMono"
				];
			})

			# IBM Plex {Sans,Serif,Mono}
			ibm-plex

			# Twemoji
			twitter-color-emoji

			# Tewi
			tewi-font

			# Uiua
			uiua386
		];

		fontDir.enable = true;
		fontconfig = {
			allowBitmaps = true;
			useEmbeddedBitmaps = true;
			defaultFonts = {
				serif     = [ theme.font.serif ];
				sansSerif = [ theme.font.sans  ];
				monospace = [ theme.font.mono  ];
			};
		};
	};
}
