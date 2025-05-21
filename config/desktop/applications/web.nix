{ pkgs, ... }:

{
	hm.programs.brave.enable = true;
	hm.programs.firefox = {
		enable = true;
		package = pkgs.wrapFirefox (pkgs.firefox-unwrapped.override { pipewireSupport = true; }) {};
		nativeMessagingHosts = with pkgs; [
			tridactyl-native
			ff2mpv
		];
	};
}
