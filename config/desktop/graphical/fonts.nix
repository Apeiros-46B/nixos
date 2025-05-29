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

			tewi-font
			uiua386

			(pkgs.iosevka.override {
				privateBuildPlan = builtins.readFile ./iosevka.toml;
				set = "Custom";
			})

			(pkgs.iosevka.override {
				privateBuildPlan = builtins.readFile ./iosevka.toml;
				set = "CustomManuscript";
			})
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
