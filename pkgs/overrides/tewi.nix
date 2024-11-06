{ final, prev }:

prev.tewi-font.overrideAttrs (prevDrv: {
	nativeBuildInputs = prevDrv.nativeBuildInputs ++ [ final.bdfresize ];

	postBuild = ''
		# upscale bdf fonts by a factor of 2
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
