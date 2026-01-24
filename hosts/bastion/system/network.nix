{ lib, ... }:

let
	interface = "eno1";
in {
	networking = {
		useDHCP = lib.mkDefault true;
		interfaces.${interface}.ipv4.addresses = [{
			address = "10.0.0.100";
			prefixLength = 24;
		}];
		defaultGateway = {
			address = "10.0.0.1";
			inherit interface;
		};
		nameservers = [ "1.1.1.1" "1.0.0.1" "8.8.8.8" "10.0.0.1" ];
	};
}
