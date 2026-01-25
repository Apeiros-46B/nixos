{ pkgs, ... }:

{
	xdg.mime.defaultApplications = {
		"inode/directory"              = "thunar.desktop";
		"application/zip"              = "xarchiver.desktop";
		"application/gzip"             = "xarchiver.desktop";
		"application/x-tar"            = "xarchiver.desktop";
		"application/x-gzip"           = "xarchiver.desktop";
		"application/x-bzip"           = "xarchiver.desktop";
		"application/x-bzip2"          = "xarchiver.desktop";
		"application/x-zip-compressed" = "xarchiver.desktop";
		"application/x-7z-compressed"  = "xarchiver.desktop";
		"application/vnd.rar"          = "xarchiver.desktop";
	};

	hm.home.packages = [ pkgs.xarchiver ];
	programs.thunar = {
		enable = true;
		plugins = with pkgs; [
			thunar-archive-plugin
			thunar-volman
		];
	};
	programs.xfconf.enable = true;
}
