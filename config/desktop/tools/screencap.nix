{ pkgs, ... }:

{
	programs.obs-studio = {
		enable = true;
		enableVirtualCamera = true;
		package = pkgs.obs-studio.override {
			cudaSupport = true;
		};
		plugins = with pkgs.obs-studio-plugins; [
			wlrobs
			droidcam-obs
			obs-backgroundremoval
			obs-pipewire-audio-capture
		];
	};
	programs.wshowkeys.enable = true;

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
