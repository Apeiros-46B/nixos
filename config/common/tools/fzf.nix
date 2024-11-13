{ pkgs, theme, ... }:

let
	wrappedFzf = pkgs.writeShellScriptBin "fzf" (with theme.colors; ''
		${pkgs.fzf}/bin/fzf \
			--height=60% --border --margin=1,0 --layout=reverse \
			--no-unicode --tabstop=4 --scroll-off=2 \
			--header="" --ellipsis='...' --pointer='+' --marker='*' --prompt='? ' \
			--color='hl+:#${purple}:bold,hl:#${purple}:bold,header:#${fg1}:bold' \
			--color='pointer:#${fg1},marker:#${purple},prompt:#${orange},spinner:#${purple}' \
			--color='bg+:#${bgVisual},bg:#${bg2},gutter:#${bg2},border:#${bg2},separator:#${bg2}' \
			--color='fg+:#${fg1}:bold,fg:#${fg2},info:#${fg4}' \
			"$@"
	'');
in {
	environment.systemPackages = with pkgs; [
		fd
		ripgrep
		sad
		wrappedFzf
	];
}
