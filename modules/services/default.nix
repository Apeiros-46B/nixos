{ pkgs, ... }:

{
	imports = [
		./keyring.nix
		./pipewire.nix
		./syncthing.nix
		./warp.nix
	];

	programs.gnupg.agent = {
		enable = true;
		enableSSHSupport = true;
		pinentryPackage = pkgs.pinentry-curses;
	};

	services = {
		printing.enable = true;
		openssh = {
			enable = true;
			settings.PermitRootLogin = "no";
		};
	};

	security.rtkit.enable = true;
}
