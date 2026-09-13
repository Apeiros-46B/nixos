{ pkgs, ... }:

{
	hm.home.packages = with pkgs; [
		(discord.override {
			withVencord = true;
			withOpenASAR = true;
		})
		signal-cli
		signal-desktop
	];
}
