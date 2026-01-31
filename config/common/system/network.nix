{ globals, ... }:

{
	networking = {
		hostName = globals.hostname;
		firewall = {
			enable = true;
			checkReversePath = "loose";
		};
	};
}
