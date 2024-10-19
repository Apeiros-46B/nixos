{ ... }:

{
	imports = [
		./boot.nix
		./locale.nix
		./user.nix
		./env.nix
		./tty.nix
	];

	networking.firewall.enable = false;
}
