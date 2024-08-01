{ pkgs }:

pkgs.stdenv.mkDerivation rec {
	pname = "openmv-ide";
	version = "4.1.5";
	
	src = pkgs.fetchzip {
		url = "https://github.com/openmv/openmv-ide/releases/download/v${version}/openmv-ide-linux-x86_64-${version}.tar.gz";
		sha256 = "bja9hNsLnFqEjmQMf77Pvjz+y7qRu+AiVz9azmiqmWo=";
	};

	nativeBuildInputs = [
		pkgs.autoPatchelfHook
	];
	autoPatchelfIgnoreMissingDeps = true;

	buildInputs = with pkgs; [
		qt6.full

		xorg.libxcb
		xorg.xcbutil
		xorg.xcbutilimage
		xorg.xcbutilkeysyms

		fontconfig
		freetype
		libpng
		libusb1

		python3
		python312Packages.pyusb
	];

	installPhase = ''
		runHook preInstall
		install -Dm 755 bin/openmvide $out/bin/openmvide

		# install icons
		for file in $(find share/icons -type f); do
			install -Dm 755 "$file" "$out/$file";
		done

		# install udev rules
		for file in share/qtcreator/pydfu/*.rules; do
			install -Dm 755 "$file" "$out/etc/udev/$(basename "$file")"
		done

		# install qtcreator libs and other things
		for file in lib/qtcreator/*.so.4 lib/qtcreator/plugins/*.so; do
			install -Dm 755 "$file" "$out/$file"
		done
		for file in $(find share/qtcreator -type f); do
			install -Dm 755 "$file" "$out/$file"
		done

		runHook postInstall
	'';
}
