{ pkgs, ... }:

{
	xdg.mime.defaultApplications = {
		"image/jpeg" = "imv.desktop";
		"image/apng" = "imv.desktop";
		"image/png"  = "imv.desktop";
		"image/gif"  = "imv.desktop";
	};

	hm.home.packages = with pkgs; [
		imv
		nicotine-plus
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
