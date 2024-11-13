{ ... }:

let
	interface = "wg0";
	port = 51820;
in {
	networking = {
		nat = {
			enable = true;
			externalInterface = "eno1";
			internalInterfaces = [ interface ];
		};
		firewall.allowedUDPPorts = [ port ];

		wireguard = {
			enable = true;
			interfaces.${interface} = {
				ips = [ "10.10.0.1/24" ];
				listenPort = port;
				privateKeyFile = "/etc/ssh"
			};
		};
	};
}
