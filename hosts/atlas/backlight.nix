{ config, pkgs, ... }:

{
	environment.systemPackages = with pkgs; [ brightnessctl ];

	# system-wide keyboard shortcuts for backlight
	# TODO: move from awesome config to this
	# services.actkbd =
	# 	let
	# 		brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
	# 	in {
	# 		enable = true;
	# 		bindings = [
	# 			{
	# 				keys = [ 224 ];
	# 				events = [ "key" ];
	# 				command = "${brightnessctl} set 10%+";
	# 			}
	# 			{
	# 				keys = [ 225 ];
	# 				events = [ "key" ];
	# 				command = "${brightnessctl} set 10%-";
	# 			}
	# 		];
	# };
}
