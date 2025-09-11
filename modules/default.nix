# IMPORTANT: never use pkgs.lib for modules that package my derivations. instead, use the
# lib input. pkgs.lib results in infinite recursion and the error doesn't tell you where it is
{ ... }:

{
	imports = [
		./dufs.nix
		./lxc.nix
		./playit.nix
		./shimmie.nix
		./wawa.nix
	];
}
