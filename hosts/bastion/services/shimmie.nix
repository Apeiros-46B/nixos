{ pkgs, ... }:

{
	my.services.shimmie = {
		enable = true;
		port = 8000;
		openFirewall = true;
	};
}
