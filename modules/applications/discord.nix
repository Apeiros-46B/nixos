{ pkgs, ... }:

{
	my.home.packages = [
		(pkgs.discord-canary.override {
			withOpenASAR = true;
			withVencord = true;
		})
	];
}
