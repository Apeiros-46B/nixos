{ pkgs, ... }:

{
	users = {
		users.nas = {};
		groups.nas.members = [ "root" "nas" "dufs" ];
	};
	
	# {{{ set up directories and symlinks
	systemd.tmpfiles.settings."10-my-nas" = {
		"/nas".d = {
			user = "nas";
			group = "nas";
			mode = "0660";
		}
		"/nas/samba".d = {
			user = "nas";
			group = "nas";
			mode = "0660";
		}

		# only accessible via samba
		"/nas/samba/priv".d = {
			user = "nas";
			group = "nas";
			mode = "0640";
		};
		# accessible via samba, read-only in dufs (password protected)
		"/nas/samba/prot".d = {
			user = "nas";
			group = "nas";
			mode = "0640";
		};
		# accessible via samba, read-only in dufs (not protected)
		"/nas/samba/pub".d = {
			user = "nas";
			group = "nas";
			mode = "0640";
		};
		# accessible via samba, read-write in dufs (password protected)
		"/nas/samba/inbox".d = {
			user = "nas";
			group = "nas";
			mode = "0660";
		};

		# dufs links
		"/nas/dufs".d = {
			user = "dufs";
			group = "nas";
			mode = "0400";
		};
		"/nas/dufs/inbox".L.argument   = "/nas/samba/inbox";
		"/nas/dufs/public".L.argument  = "/nas/samba/pub";
		"/nas/dufs/private".L.argument = "/nas/samba/prot";
	};
	# }}}
	
	# samba for local management and transfers
	services.samba = {
		# TODO set up samba
	};

	my.services.dufs = {
		enable = true;
		config = {
			serve-path = "/nas/dufs";
			log-file = "/var/log/dufs.log";
			compress = "medium";

			auth = [
				# TODO: make the passwords 1,2 (sha512 hashed)
				"inbox:${1}@/inbox:rw,/public:ro"
				"apeiros:${2}@/:ro"
				"@/public:ro"
			];

			allow-all = false;
			allow-upload = true;
			allow-delete = false;
			allow-search = true;
			allow-symlink = true;
			allow-archive = true;

			render-index = false;
			render-try-index = false;
			render-spa = false;

			enable-cors = true;
		};
	};
}
