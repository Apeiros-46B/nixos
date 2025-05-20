{ pkgs, ... }:

{
	hm.programs.brave.enable = true;
	hm.programs.firefox.enable = true;

	hm.home.packages = with pkgs; [
		(discord-canary.override {
			withOpenASAR = true;
			withVencord = true;
		})
	];
}
