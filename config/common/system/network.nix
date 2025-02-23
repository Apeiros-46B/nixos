{ config, globals, ... }:

{
	networking.hostName = globals.hostname;

	# fake domains for my IPs
	# sops.secrets.fake-domains-hostfile = {
	# 	sopsFile = ./Secrets.yaml;
	# 	# owner = "root";
	# 	# group = "root";
	# 	# mode = "0777";
	# 	neededForUsers = true;
	# };
	# networking.hostFiles = [
	# 	config.sops.secrets.fake-domains-hostfile.path
	# ];
}
