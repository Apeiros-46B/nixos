{ pkgs, theme, ... }:

{
	fonts = {
		packages = with pkgs; [
			# Microsoft fonts
			corefonts
			ibm-plex
			twitter-color-emoji

			(nerdfonts.override {
				fonts = [
					"JetBrainsMono"
					"Iosevka"
					"DejaVuSansMono"
				];
			})

			# my.fairfax-font # TODO: currently doesn't build
			tewi-font
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
