{ pkgs, ... }:

{
	virtualisation.containers.enable = true;
	virtualisation.oci-containers.backend = "docker";
	virtualisation.docker = {
		enable = true;
		daemon.settings = {
			userland-proxy = false;
			experimental = true;
			metrics-addr = "0.0.0.0:9323";
			ipv6 = true;
			fixed-cidr-v6 = "fd00::/80";
		};
	};
	environment.systemPackages = with pkgs; [
		docker-compose
	];
}
