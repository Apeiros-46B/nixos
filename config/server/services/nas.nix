{ pkgs, ... }:

{}
# {
#         # users and groups
#         users = {
#         	users.samba = {};
#         	groups.samba.members = [ "root" "samba" ];
# 
#         	users.dufs.packages = [ pkgs.dufs ];
#         	groups.dufs.members = [ "dufs" ];
#         };
# 
#         # directories
#         systemd.tmpfiles.settings.samba = {
#         	"/mnt/shares/priv".d = {
#         		user = "root"; # TODO: can samba change ownership to non-root? would be better for samba user to own files?
#         		group = "samba";
#         		mode = "0760";
#         	};
#         	"/mnt/shares/pub".d = {
#         		user = "root";
#         		group = "samba";
#         		mode = "0764";
#         	};
#         };
# 
#         # samba for local management and transfers
#         services.samba = {
#         	# TODO set up samba
#         };
# 
#         # world-accessible read-only dufs for non-critical files
#         systemd.services.dufs-public-samba = {
#         	description = "Start dufs on samba public share";
#         	wantedBy = [ "multi-user.target" ];
#         	wants = [ "network-online.target" ];
#         	after = [ "network-online.target" ];
# 
#         	serviceConfig = {
#         		Type = "simple";
#         		User = "dufs";
#         		Group = "dufs";
#         		ExecStart = "${pkgs.dufs}/bin/dufs --path-prefix /pub --config /etc/dufs/config.yaml";
#         	};
#         };
#         environment.etc."dufs/config.yaml".text = ''
#         	serve-path: '/mnt/shares/pub'
#         	auth:
#         		- apeiros:${1}@/:ro # TODO: sops-managed password hashed with sha512 (the hash is stored in this config), make it rw as well
#         		- '@/:ro'           # Guest users can only read
#         	allow-all: false
#         	allow-upload: false
#         	allow-delete: false
#         	allow-search: true
#         	allow-symlink: false
#         	allow-archive: false
#         	enable-cors: true
#         	render-index: false
#         	render-try-index: false
#         	render-spa: false
#         	assets: /etc/dufs/assets/
#         	log-file: /var/log/dufs.log
#         	compress: medium
#         '';
# }
