{ config, pkgs, ... }:

{
	my.services.flameshot = {
		enable = true;
		settings = {
			General = {
				disabledTrayIcon = true;
				showStartupLaunchMessage = false;
			};
		};
	};
}
