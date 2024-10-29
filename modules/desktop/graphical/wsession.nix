{ functions, ... }:

functions.linkDots "river" {
	programs.river.enable = true;
	hm.xdg.configFile."river/scale".text = ''
		scale=1
	'';
}
