{ pkgs }:

let
	version = "2024-06-01";
in pkgs.stdenv.mkDerivation {
	pname = "fairfax-font";
	version = builtins.replaceStrings ["-"] ["."] version;

	src = pkgs.fetchzip {
		url = "https://github.com/kreativekorp/open-relay/releases/download/${version}/Fairfax.zip";
		sha256 = "rUl/C250pJBal69ThtWhPMFe182nnZmk5UUA7eDrZeA=";
		stripRoot = false;
	};

	nativeBuildInputs = with pkgs; [
		otf2bdf
		bdfresize
		xorg.mkfontscale
	];

	# convert ttf to bdf, then upscale bdf fonts by a factor of 2
	buildPhase = ''
		for f in ./*.ttf; do
			g="$(echo "$f" | sed 's/ttf$/bdf/')";
			otf2bdf "$f" | bdfresize -f 2 > "$g";
		done
	'';

	installPhase = ''
		fontDir="$out/share/fonts/misc";
		install -m 644 -D ./*.bdf -t "$fontDir";
		mkfontdir "$fontDir";
	'';
}
