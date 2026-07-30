{ ... }:

{
	networking.firewall = {
		allowedTCPPorts = [ 42420 25565 ];
		allowedUDPPorts = [ 42420 24454 ];
	};
	my.services.rproxy.extraProxies = {
		minecraft = {
			type = "tcp";
			localPort = 25565;
		};
		minecraft-simplevoicechat = {
			type = "udp";
			localPort = 24454;
		};
		vintagestory = {
			type = "tcp";
			localPort = 42420;
		};
		vintagestory-udp = {
			type = "udp";
			localPort = 42420;
		};
	};

	# minecraft prometheus exporter
	services.prometheus.scrapeConfigs = [
		{
			job_name = "minecraft";
			static_configs = [{
				targets = [ "localhost:25566" ];
			}];
		}
	];
}
