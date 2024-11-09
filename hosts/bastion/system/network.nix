{ lib, ... }:

let
	interface = "eno1";
in {
	# networking = {
	# 	# static ip
	# 	interfaces.${interface} = {
	# 		useDHCP = false;
	# 		ipv4.addresses = [{
	# 			address = "192.168.0.4";
	# 			prefixLength = 24;
	# 		}];
	# 	};
	# 	defaultGateway = {
	# 		address = "192.168.0.1";
	# 		inherit interface;
	# 	};
	# };
	
	networking = {
		useDHCP = lib.mkDefault true;
		interfaces.${interface}.ipv4.addresses = [{
			address = "192.168.0.4";
			prefixLength = 24;
		}];
		defaultGateway = {
			address = "192.168.0.1";
			inherit interface;
		};
		nameservers = [ "1.1.1.1" "8.8.8.8" "192.168.0.1" ];
	};
}
