{ pkgs }:

pkgs.stdenv.mkDerivation rec {
	pname = "ubuntu-server";
	version = "24.04.3";

	src = pkgs.fetchurl {
		url = "https://releases.ubuntu.com/${version}/ubuntu-${version}-live-server-amd64.iso";
		sha256 = "w1FL8AVhgNCTdkYqehtPITwdbo6mf65cJQmcb9PYJ0s=";
	};

	phases = [ "installPhase" ];
	installPhase = ''
		mkdir -p $out
		install -Dm 755 $src $out/installer.iso
	'';
}
