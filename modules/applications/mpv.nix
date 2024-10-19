{ pkgs, ... }:

{
	my.home.packages = with pkgs; [
		mpv
		ffmpeg

		mpvScripts.uosc
		mpvScripts.mpris
		mpvScripts.thumbfast

		mpvScripts.sponsorblock
		mpvScripts.cutter
	];
}
