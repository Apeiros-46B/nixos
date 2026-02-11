{ inputs, pkgs, system, functions, globals, theme, ... }:

let
	quickshellSrcDir = "${globals.dir.cfg}/quickshell/src";
	themeQml = pkgs.writeText "Theme.qml" ''
		pragma Singleton
		import QtQml
		QtObject {
			${builtins.concatStringsSep "\n" (
				pkgs.lib.mapAttrsToList (k: v:
					"readonly property string ${k}: \"${v}\""
				) theme.colorsHash
			)}
			readonly property string fontMono: "${theme.font.mono}"
			readonly property string fontSans: "${theme.font.sans}"
		}
	'';
	quickshellThemePkg = pkgs.runCommand "quickshell-theme-module" {} ''
		mkdir -p $out/lib/qt-6/qml/NixTheme
		echo "module NixTheme" > $out/lib/qt-6/qml/NixTheme/qmldir
		echo "singleton Theme 1.0 Theme.qml" >> $out/lib/qt-6/qml/NixTheme/qmldir
		ln -s ${themeQml} $out/lib/qt-6/qml/NixTheme/Theme.qml
	'';
	qmlPaths = [
		quickshellSrcDir
		"${quickshellThemePkg}/lib/qt-6/qml"
		"${inputs.quickshell.packages.${system}.default}/lib/qt-6/qml"
		"${inputs.qml-niri.packages.${system}.default}/lib/qt-6/qml"
		"${pkgs.qt6.qtdeclarative}/lib/qt-6/qml"
		"${pkgs.qt6.qtwayland}/lib/qt-6/qml"
		"${pkgs.qt6.qt5compat}/lib/qt-6/qml"
	];
	quickshellPkg = inputs.quickshell.packages.${system}.default.withModules [
		quickshellThemePkg
		inputs.qml-niri.packages.${system}.default
		pkgs.qt6.qtwayland
		pkgs.qt6.qt5compat
	];
	qmllsWrappedPkg = pkgs.runCommand "qmlls-wrapped" {
		nativeBuildInputs = [ pkgs.makeWrapper ];
	} ''
		mkdir -p $out/bin
		makeWrapper ${pkgs.qt6.qtdeclarative}/bin/qmlls $out/bin/qmlls \
			--prefix QML_IMPORT_PATH : "${builtins.concatStringsSep ":" qmlPaths}"
	'';
in functions.linkImpure "quickshell" {
	hm.home.packages = with pkgs; [
		qmllsWrappedPkg
		quickshellPkg
		swaylock
		swww
	];

	hm.systemd.user.services.quickshell = {
		Unit = {
			Description = "Quickshell";
			PartOf = [ "graphical-session.target" ];
			After = [ "graphical-session.target" ];
			ConditionEnvironment = "NIRI_SOCKET";
		};
		Service = {
			Environment = "QML_IMPORT_PATH=${quickshellSrcDir}";
			ExecStart = "${quickshellPkg}/bin/quickshell";
			Restart = "on-failure";
			RestartSec = 1;
		};
		Install.WantedBy = [ "graphical-session.target" ];
	};

	hm.services.swww.enable = true;

	hm.services.mako = {
		enable = true;
		settings = with theme.colorsHash; {
			default-timeout = 5000;
			border-size = 0;
			border-radius = 0;
			padding = "16";
			margin = "24";
			max-icon-size = 48;
			width = 400;
			text-color = fg0;
			progress-color = green;
			background-color = bg1;
		};
	};
}
