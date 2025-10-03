{ globals, ... }:

{
	my.containers.tbots = {
		enable = true;
		user = globals.user;
		dataDir = globals.dir.vm;
		waylandDisplay = 1;
		packages = [
			"tree"
			"tmux"
			"mesa-utils" "ripgrep" ];
		envExtra = ''
			eval "$(dircolors -b)"
		'';
		bashrcExtra = ''
			alias ls='ls -F --color=auto --group-directories-first'
			alias la='ls -A'
			alias ll='ls -lh'
			alias l='ls -lAh'
			alias tree='tree --dirsfirst'
			launch() {
				"$@" > /dev/null 2>&1 & disown
			}
			prompt_accent() {
				if [ $? -ne 0 ]; then
					tput setab 1
				elif [ "$(whoami)" = root ]; then
					tput setab 5
				else
					tput setab 3
				fi
			}
			PS1='$(prompt_accent) $(tput setab 8) \h.\w $(tput sgr0) '
		'';
	};
}
