{ config, pkgs, ... }:

{
	# currently broken build in nixpkgs unstable, wait
	# services.fprintd = {
	# 	enable = true;
	# 	tod = {
	# 		enable = true;
	# 		driver = pkgs.libfprint-2-tod1-vfs0090;
	# 	};
	# };
}
