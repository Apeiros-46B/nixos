{ ... }:

{
	imports = [
		./backend
		./discord
		./network
		./storage
	];

	# TODO/TEMPORARY: minecraft server
	services.frp.settings.proxies = [
		{
			name = "minecraft";
			type = "tcp";
			localIP = "127.0.0.1";
			localPort = 25565;
			remotePort = 25565;
		}
	];
}
