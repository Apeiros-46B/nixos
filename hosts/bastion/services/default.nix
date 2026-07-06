{ ... }:

{
	imports = [
		./backend
		./discord
		./network
		./storage
	];

	# TODO/TEMPORARY: minecraft and vintage story servers
	networking.firewall = {
		allowedTCPPorts = [ 42420 25565 ];
		allowedUDPPorts = [ 42420 ];
	};
	services.frp.settings.proxies = [
		{
			name = "minecraft";
			type = "tcp";
			localIP = "127.0.0.1";
			localPort = 25565;
			remotePort = 25565;
		}
		{
			name = "vintagestory";
			type = "tcp";
			localIP = "127.0.0.1";
			localPort = 42420;
			remotePort = 42420;
		}
		{
			name = "vintagestory";
			type = "udp";
			localIP = "127.0.0.1";
			localPort = 42420;
			remotePort = 42420;
		}
	];
}
