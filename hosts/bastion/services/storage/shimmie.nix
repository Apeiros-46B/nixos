{ globals, ... }:

{
	my.services.shimmie = {
		enable = true;
		openFirewall = true;
		nginx = {
			virtualHost = "img.${globals.net.tsDomain}";
			acmeHost = globals.net.tsDomain;
		};
	};
}
