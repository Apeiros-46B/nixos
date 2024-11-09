{ ... }:

{
	users = {
		users.samba = {
			isSystemUser = true;
			group = "nas";
		};
		groups.nas.members = [ "root" "samba" "dufs" ];
	};
	
	# {{{ set up directories and symlinks
	systemd.tmpfiles.settings."10-my-nas" = {
		"/nas".d = {
			user = "root";
			group = "nas";
			mode = "0770";
		};
		"/nas/samba".d = {
			user = "samba";
			group = "nas";
			mode = "0770";
		};

		# only accessible via samba
		"/nas/samba/priv".d = {
			user = "samba";
			group = "nas";
			mode = "0750";
		};
		# accessible via samba, read-only in dufs (password protected)
		"/nas/samba/prot".d = {
			user = "samba";
			group = "nas";
			mode = "0750";
		};
		# accessible via samba, read-only in dufs (not protected)
		"/nas/samba/pub".d = {
			user = "samba";
			group = "nas";
			mode = "0750";
		};
		# accessible via samba, read-write in dufs (password protected)
		"/nas/samba/inbox".d = {
			user = "samba";
			group = "nas";
			mode = "0770";
		};

		# dufs links
		"/nas/dufs".d = {
			user = "dufs";
			group = "nas";
			mode = "0550";
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
		openFirewall = true;
		group = "nas";
		config = {
			port = 5000;
			serve-path = "/nas/dufs";
			log-file = "/var/log/dufs.log";
			compress = "medium";
	
			auth = [
				# TODO: make the passwords (they are currently 1,2) (should be sha512 hashed sops managed)
				"inbox:${"1"}@/inbox:ro,/public:ro"
				"apeiros:${"2"}@/:ro"
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
