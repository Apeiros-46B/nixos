{ pkgs, ... }:

{
	imports = [
		./brave.nix
		./discord.nix
		./emacs.nix
		./nvim.nix
		./sioyek.nix
	];

	my.home.packages = with pkgs; [
		mpv
		gnome-network-displays # TODO: move gnome-network-displays to a new file
		openmvide
	];
	services.udev.packages = [ pkgs.openmvide ];

	networking.firewall = {
		allowedTCPPorts = [ 7236 7250 ];
		allowedUDPPorts = [ 7236 5353 ];
	};
}
