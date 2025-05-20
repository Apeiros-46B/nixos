{ pkgs, ... }:

{
	hm.programs.obs-studio = {
		enable = true;
		plugins = with pkgs.obs-studio-plugins; [
			wlrobs
			obs-backgroundremoval
			obs-pipewire-audio-capture
		];
	};

	hm.home.packages = with pkgs; [ grim slurp ];

	hm.services.flameshot = {
		enable = true;
		package = (pkgs.flameshot.override { enableWlrSupport = true; });
		settings = {
			General = {
				disabledTrayIcon = true;
				showStartupLaunchMessage = false;
			};
		};
	};
}
