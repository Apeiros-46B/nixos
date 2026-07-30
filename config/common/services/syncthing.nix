{ ... }:

{
	networking.firewall.allowedTCPPorts = [ 8384 ];

	services.syncthing = {
		enable = true;
		overrideDevices = false;
		overrideFolders = false;
		openDefaultPorts = true;
		settings.options = {
			relaysEnabled = false;
			urAccepted = -1;
		};
	};

	systemd.services.syncthing = {
		after = [ "network-online.target" "tailscaled.service" ];
		wants = [ "network-online.target" ];
	};
}
