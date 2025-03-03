{ pkgs }:

pkgs.stdenv.mkDerivation rec {
	pname = "shimmie";
	version = "9be9f3e";

	src = pkgs.fetchFromGitHub {
		owner = "shish";
		repo = "shimmie2";
		rev = "9be9f3e7f91ba3a4b7e964445259607bee4cf1a3";
		hash = "sha256-Z7N1U4MSeb9jcz+c4C2ClNKSFAd/1j7wZq68w+ANeB0=";
	};

	installPhase = ''
		runHook preInstall
		cp -r . "$out"
		runHook postInstall
	'';
}
