{ pkgs }:

pkgs.tewi-font.overrideAttrs (prev: {
	nativeBuildInputs = prev.nativeBuildInputs ++ [ pkgs.bdfresize ];

	postBuild = ''
		# upscale bdf fonts
		for f in ./*.bdf; do
			bdfresize "$f" -f 2 > "$(echo "$f" | sed 's/11/22/')"
		done
	'';
	
  installPhase = ''
    fontDir="$out/share/fonts/misc"
    install -m 644 -D ./*.bdf -t "$fontDir"
    mkfontdir "$fontDir"
  '';
})
