{ config, lib, globals, ... }:

let
	pubPort = 2282;
	privPort = 2283;
	pubDomain = "pic.${globals.net.pubDomain}";
	tsDomain = "pic.${globals.net.tsDomain}";
	immichDir = "/nas/pictures";
in {
	systemd.tmpfiles.settings =  {
		"10-nas-immich".${immichDir}.d = {
			user = "root";
			group = "nas";
			mode = "0770";
		};
		immich.${immichDir}.e.mode = lib.mkForce "0750";
	};

	# force new files created by the immich processes to retain group read permissions
	systemd.services.immich-server.serviceConfig.UMask = lib.mkForce "0027";
	systemd.services.immich-machine-learning.serviceConfig.UMask = lib.mkForce "0027";

	my.services.rproxy = {
		domains.${pubDomain} = pubPort;
		tsDomains.${tsDomain} = privPort;
	};

	sops.secrets.immich-env = {
		sopsFile = ./Secrets.yaml;
		owner = "immich";
		group = "nas";
		mode = "0400";
	};

	services.immich = {
		enable = true;
		group = "nas";
		host = "0.0.0.0";
		port = privPort;
		openFirewall = true;
		mediaLocation = immichDir;
		settings = {
			server.externalDomain = "https://${pubDomain}"; # public proxy
			newVersionCheck.enabled = false;
		};
	};

	services.immich-public-proxy = {
		enable = true;
		port = pubPort;
		immichUrl = "127.0.0.1:${toString privPort}";
	};
}
