{ pkgs }:

pkgs.stdenv.mkDerivation {
	pname = "verticalfox";
	version = "7eca918";

	src = pkgs.fetchFromGitHub {
		owner = "christorange";
		repo = "VerticalFox";
		rev = "7eca918ef2bd70148f41b95f5bb917150e1094a2";
		hash = "sha256-0tBNEXahWM54KDny/zMPyL8UbvD5FklIJN4Ujh802rQ=";
	};

	installPhase = ''
		runHook preInstall
		cp -r . "$out"
		runHook postInstall
	'';
}
