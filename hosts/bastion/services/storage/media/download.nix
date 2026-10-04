{ config, ... }:

let
	quiPort = 5252;
in {
	my.services.rproxy.tsDomains."qb.ts.apeiros.xyz" = quiPort;

	# SETUP: first-time need to point qui to qb, use vpn bridge addr 192.168.15.1:8085
	# see https://nixarr.com/wiki/examples/example-4/
	nixarr.qbittorrent = {
		enable = true;
		vpn.enable = true;
		openFirewall = true;

		peerPort = 50000;
		webuiPort = quiPort;

		# disable DHT/PeX for private trackers
		# privateTrackers.disableDhtPex = true;
		# TODO: there are probably some other options to enable if using private tracker

		# https://github.com/qbittorrent/qBittorrent/wiki/Explanation-of-Options-in-qBittorrent
		extraConfig = {
			BitTorrent = {
			};
		};
	};
}
