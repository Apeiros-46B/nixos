{ pkgs, theme, ... }:

let
	wrappedFzf = pkgs.writeShellScriptBin "fzf" ''
		${pkgs.fzf}/bin/fzf \
			--height=60% --border --margin=1,0 --layout=reverse \
			--no-unicode --tabstop=4 --scroll-off=2 \
			--header="" --ellipsis='...' --pointer='+' --marker='*' --prompt='? ' \
			--color='hl+:5:bold,hl:5:bold,header:-1:bold' \
			--color='pointer:-1,marker:5,prompt:243,spinner:5' \
			--color='bg+:250,bg:233,gutter:233,border:233,separator:233' \
			--color='fg+:-1:bold,fg:7,info:7' \
			"$@"
	'';
in {
	environment.systemPackages = with pkgs; [
		fd
		ripgrep
		sad
		wrappedFzf
	];
}
