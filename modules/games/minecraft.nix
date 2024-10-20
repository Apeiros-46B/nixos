{ pkgs, ... }:

{
	programs.java.enable = true;

	environment.systemPackages = with pkgs; [
		# jdk8
		# jdk11
		jdk17
		# jdk21
	];

	hm.home.packages = with pkgs; [
		ferium
		prismlauncher
		fabric-installer
	];
}
