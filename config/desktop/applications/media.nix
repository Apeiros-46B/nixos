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
			version = "unstable-2026-08-29-d70d2be";
			src = fetchFromGitHub {
				owner = "nicotine-plus";
				repo = "nicotine-plus";
				rev = "d70d2be324cf3bbf3ecf7575eca39de9e2441738";
				hash = "sha256-yd9qxQCBRh4ns4jr6nIFgbV9v4yutk5dFIjvtUjmbA8=";
			};
		}))

		imv
		quodlibet-full

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
