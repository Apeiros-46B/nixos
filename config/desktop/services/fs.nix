{ config, globals, ... }:

{
	# for windows dual boot
	boot.supportedFilesystems = [ "ntfs" ];

	users.users.${globals.user}.extraGroups = [
		config.services.davfs2.davGroup
	];
	services.davfs2.enable = true;
	services.gvfs.enable = true;
}
