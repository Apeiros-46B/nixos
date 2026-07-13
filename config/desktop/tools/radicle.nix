{ pkgs, ... }:

{
	hm.home.packages = with pkgs; [
		radicle-node
	];
}
