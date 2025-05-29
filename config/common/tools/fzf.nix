{ pkgs, theme, ... }:

let
	wrappedFzf = pkgs.writeShellScriptBin "fzf" (with theme.colors; ''
		${pkgs.fzf}/bin/fzf \
			--height=60% --border --margin=1,0 --layout=reverse \
			--no-unicode --tabstop=4 --scroll-off=2 \
			--header="" --ellipsis='...' --pointer='+' --marker='*' --prompt='? ' \
			--color='hl+:#${purple}:bold,hl:#${purple}:bold,header:#${fg0}:bold' \
			--color='pointer:#${fg0},marker:#${purple},prompt:#${orange},spinner:#${purple}' \
			--color='bg+:#${bgPurple},bg:#${bg1},gutter:#${bg1},border:#${bg1},separator:#${bg1}' \
			--color='fg+:#${fg0}:bold,fg:#${fg3},info:#${fg4}' \
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
