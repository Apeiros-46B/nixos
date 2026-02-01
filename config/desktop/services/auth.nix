{ pkgs, ... }:

{
	security.polkit.enable = true;
	services.gnome.gnome-keyring.enable = true;
	programs.gnupg.agent = {
		enable = true;
		enableSSHSupport = false; # let gnome keyring handle ssh
	};
	programs.seahorse.enable = true;
	environment.systemPackages = with pkgs; [ libsecret gcr ];
}
