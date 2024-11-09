{ pkgs }:

pkgs.stdenv.mkDerivation rec {
	pname = "playit";
	version = "4.1.5";
	
	src = pkgs.fetchurl {
		url = "https://github.com/playit-cloud/playit-agent/releases/download/v0.15.26/playit-linux-amd64";
		sha256 = "238Ck3+/2Kazv3TT3qcwgl4kGWxrfcwCiqQQ2erZhl0=";
	};

	nativeBuildInputs = [
		pkgs.autoPatchelfHook
	];

	phases = ["installPhase" "patchPhase"];
	installPhase = ''
		mkdir -p $out/bin
		install -Dm 755 $src $out/bin/playit
	'';
}
