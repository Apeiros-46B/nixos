{ config, lib, pkgs, globals, ... }:

let
	gio_modules = "${pkgs.gvfs}/lib/gio/modules:${pkgs.dconf}/lib/gio/modules";
in {
	# for windows dual boot
	boot.supportedFilesystems = [ "ntfs" ];

	hm.home.packages = [ pkgs.sshfs ];

	users.users.${globals.user}.extraGroups = [
		config.services.davfs2.davGroup
	];
	services.davfs2.enable = true;

	services.gvfs.enable = true;
	environment.variables.GIO_EXTRA_MODULES = lib.mkForce gio_modules;
	environment.sessionVariables.GIO_EXTRA_MODULES = lib.mkForce gio_modules;
}
