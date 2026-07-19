{ config, lib, globals, ... }:

let
	pubPort = 2282;
	privPort = 2283;
	pubDomain = "pic.${globals.net.pubDomain}";
	tsDomain = "pic.${globals.net.tsDomain}";
	immichDir = "/mnt/nas/pictures";
in {
	systemd.tmpfiles.settings."10-nas-immich".${immichDir}.d = {
		user = "immich";
		group = "immich";
		mode = "0700"; # immich resets it to 0700 anyways
	};

	my.services.rproxy = {
		domains.${pubDomain} = pubPort;
		tsDomains.${tsDomain} = privPort;
	};

	sops.secrets.immich-env = {
		sopsFile = ./Secrets.yaml;
		owner = "immich";
		group = "immich";
		mode = "0400";
	};

	services.immich = {
		enable = true;
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
