{ pkgs, ... }:

{
	my.home.packages = with pkgs; [
		(discord-canary.override {
			withOpenASAR = true;
			withVencord = true;
		})
	];
}
