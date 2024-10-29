{ pkgs, globals, ... }:

{
	# # users and groups
	# users = {
	# 	users.dufs.packages = [ pkgs.dufs ];
	# 	groups.nas.members = [ "root" globals.user ];
	# };

	# # directories
	# systemd.tmpfiles.settings.samba = {
	# 	"/mnt/shares/private".d = {
	# 		user = "root";
	# 		group = "nas";
	# 		mode = "0660";
	# 	};
	# 	"/mnt/shares/protected".d = {
	# 		user = "root";
	# 		group = "nas";
	# 		mode = "0664";
	# 	};
	# 	"/mnt/shares/public".d = {
	# 		user = "root";
	# 		group = "nas";
	# 		mode = "0664";
	# 	};
	# };

	# # samba for local management and transfers
	# services.samba = {
		
	# };

	# # world-accessible read-only dufs for non-critical files
	# systemd.services.dufs = {
	# 	description = "Start dufs";

	# 	serviceConfig = {
	# 		Type = "oneshot";
	# 		ExecStart = "";
	# 	};
	# };
}
