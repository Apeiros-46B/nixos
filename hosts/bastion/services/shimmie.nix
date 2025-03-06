{ pkgs, ... }:

{
	my.services.shimmie = {
		enable = true;
		openFirewall = true;
		nginx.virtualHost = "img.apeiros.xyz";
	};
}
