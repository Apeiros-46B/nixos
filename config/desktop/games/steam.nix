{ pkgs, ... }:

{
	programs.steam = {
		enable = true;
		remotePlay.openFirewall = true;
		dedicatedServer.openFirewall = true;
	};

	hm.home.packages = [ pkgs.steam-run ];
}
