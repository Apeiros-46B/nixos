{ pkgs, ... }:

{
	xdg.mime.defaultApplications = {
		"image/jpeg" = "imv.desktop";
		"image/apng" = "imv.desktop";
		"image/png"  = "imv.desktop";
		"image/gif"  = "imv.desktop";
	};

	hm.home.packages = with pkgs; [
		(nicotine-plus.overrideAttrs (oldAttrs: {
			version = "unstable-2026-08-29-3773374";
			src = fetchFromGitHub {
				owner = "nicotine-plus";
				repo = "nicotine-plus";
				rev = "377337407872bb0843bb9966e4bb76b6dfd59c1c";
				hash = "sha256-UEed0EJuoXRemVTgRuO7wuxd7vHV8hKeisL6Wfi8m6o=";
			};
		}))
		(quodlibet-full.overrideAttrs (oldAttrs: {
			version = "patched-2026-10-27-eac8272";
			src = fetchFromGitHub {
				owner = "quodlibet";
				repo = "quodlibet";
				rev = "eac82723b2ee257e8fa8e8e646e32f7ee3dbb319";
				hash = "sha256-dWSzhSYhNuy0l3WSJto103C1n+DWYMoIyd1B3xA2UM0=";
			};
			postInstall = "ln -s quodlibet-cmd $out/bin/quodlibet";
		}))

		imv

		yt-dlp
		ffmpeg
		playerctl
	];

	hm.programs.mpv = {
		enable = true;
		scripts = with pkgs; [
			mpvScripts.uosc
			mpvScripts.mpris
			mpvScripts.thumbfast
			mpvScripts.sponsorblock
			mpvScripts.cutter
		];
	};
}
