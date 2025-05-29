{ pkgs, functions, ... }:

functions.linkImpure "emacs" {
	xdg.mime.defaultApplications."text/org" = "emacsclient.desktop";

	hm.programs.emacs = {
		enable = true;
		package = pkgs.emacs-pgtk;
	};
	hm.home.packages = [
		pkgs.texlive.combined.scheme-full
	];

	# define org mime type
	hm.xdg.dataFile."mime/packages/org.xml".text = ''
		<?xml version="1.0" encoding="utf-8"?>
		<mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
			<mime-type type="text/org">
				<glob pattern="*.org"/>
					<comment>Org Document</comment>
				<icon name="x-office-document" />
			</mime-type>
		</mime-info>
	'';
}
