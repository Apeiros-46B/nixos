{ pkgs }:

let
	bnp = pkgs.fetchurl {
		url = "https://github.com/kreativekorp/bitsnpicas/releases/download/v2.1/BitsNPicas.jar";
		sha256 = pkgs.lib.fakeHash;
	};
in pkgs.writeShellScriptBin "bitsnpicas" ''
	${pkgs.jdk}/bin/java -jar ${bnp} "$@"
''
