{ globals, ... }:

{
	users.users.${globals.user} = {
		uid = globals.uid;
		isNormalUser = true;
		extraGroups = [ "wheel" ];
	};
}
