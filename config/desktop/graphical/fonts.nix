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

			uiua386
			departure-mono

			(iosevka.override {
				privateBuildPlan = builtins.readFile ./iosevka.toml;
				set = "Custom";
			})
			(iosevka.override {
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
				emoji     = [ theme.font.emoji      ];
			};
			localConf = ''
				<?xml version="1.0"?>
				<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
				<fontconfig>
					<match target="font">
						<test name="family" compare="eq">
							<string>Departure Mono</string>
						</test>
						<edit name="hinting" mode="assign">
							<bool>true</bool>
						</edit>
						<edit name="autohint" mode="assign">
							<bool>false</bool>
						</edit>
						<edit name="antialias" mode="assign">
							<bool>false</bool>
						</edit>
					</match>
				</fontconfig>
			'';
		};
	};

	environment.variables.EMOJI_FONT = theme.font.emoji;
}
