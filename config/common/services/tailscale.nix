{ ... }:

{
	# TODO:
	# Warning: UDP GRO forwarding is suboptimally configured on eno1, UDP forwarding throughput
	# capability will increase with a configuration change.
	# - See https://tailscale.com/s/ethtool-config-udp-gro
	# - See https://github.com/NixOS/nixpkgs/issues/411980
	services.tailscale = {
		enable = true;
		extraSetFlags = [ "--netfilter-mode=nodivert" ];
		extraDaemonFlags = [ "--no-logs-no-support" ];
	};
	networking.firewall.trustedInterfaces = [ "tailscale0" ];
}
