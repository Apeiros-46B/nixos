# TODO: fix
{ config, globals, ... }:

{
	services.davfs2.enable = true;
	users.users.${globals.user}.extraGroups = [ config.services.davfs2.davGroup ];
}
