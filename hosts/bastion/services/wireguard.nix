{ ... }:

let
	interface = "wg0";
in {
	networking = {
		nat = {
			enable = true;
			externalInterface = "eno1";
			internalInterfaces = [ interface ];
		};
		firewall.allowedUDPPorts = [ 51820 ];

		wireguard = {
			enable = true;
			interfaces.${interface} = {
				
			};
		};
	};
}
