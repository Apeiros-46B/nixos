{ pkgs, ... }:

{
	environment.systemPackages = with pkgs; [
		jdk8
		jdk11
		jdk21
	];

	programs.java = {
		enable = true;
		package = pkgs.jdk21;
	};

	hm.home.packages = [ pkgs.prismlauncher ];
}
