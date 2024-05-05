{ functions, ... }:

functions.linkDots "river" {
	programs.river.enable = true;
	my.xdg.configFile."river/scale".text = ''
		scale=1
	'';
}
