{ config, pkgs, globals, ... }:

let
	# make prompts with the specified accent color
	mkPS1   = color: "%F{0}%B%(0?.%K{${color}} .%K{1} )%(1j.&%j .)%K{0}%f %~ %k%b ";
	mkPS2   = color: "%K{${color}} %K{0}%B + %b%k ";
	mkPS3   = color: "%K{${color}} %K{0}%B > %b%k ";
	rprompt = ''$([ $SSH_TTY ] && echo "%K{0}%B @%m %F{0}%K{2} %k%f%b")'';
in {
	# make zsh the default shell system-wide
	users.defaultUserShell = pkgs.zsh;
	environment.shells = [ pkgs.zsh ];

	# {{{ system-wide shell aliases
	environment.shellAliases =
		let
			cfg = globals.dir.nix;
			name = globals.hostname;
		in
	{
		# preferred arguments
		ls = "ls -F --color=auto --group-directories-first";
		ip = "ip --color";

		# utility
		re = "exec \"$0\"";
		l  = "ls -lAh";
		ll = "ls -lh";
		la = "ls -A";

		# NixOS
		# TODO: make config directory autodetect, currently it's fixed to ~/.config/nixos, needs to be in /etc/nixos on bastion
		gen       = "readlink /nix/var/nix/profiles/system | cut -d- -f2";
		rebuild   = "sudo nixos-rebuild switch --flake '${cfg}#${name}'";
		update    = "pushd '${cfg}'; nix flake update; reb --upgrade; popd";
		hm        = "home-manager";
		hmrebuild = "home-manager switch --flake '${cfg}#${name}'";
	};
	# }}}

	# {{{ system-wide zsh configuration
	programs.zsh = {
		enable = true;

		# {{{ prompt for root user
		promptInit = ''
			PS1='${mkPS1 "5"}'
			PS2='${mkPS2 "5"}'
			PS3='${mkPS3 "5"}'
			RPROMPT='${rprompt}'
			ZLE_RPROMPT_INDENT=0
		'';
		# }}}

		setOptions = [
			# {{{ options
			# completion
			"NO_NOMATCH"
			"LIST_PACKED"
			"ALWAYS_TO_END"
			"GLOB_COMPLETE"
			"COMPLETE_IN_WORD"
			"COMPLETE_ALIASES"

			# jobs
			"AUTO_CONTINUE"
			"LONG_LIST_JOBS"

			# history
			"SHARE_HISTORY"
			"HIST_VERIFY"
			"HIST_IGNORE_SPACE"

			# misc
			"AUTO_CD"
			"EXTENDED_GLOB"
			"INTERACTIVE_COMMENTS"
			"PROMPT_SUBST"
			# }}}
		];

		shellAliases = {
			# {{{
			# cd to directory stack
			"1" = "cd -1";
			"2" = "cd -2";
			"3" = "cd -3";
			"4" = "cd -4";
			"5" = "cd -5";
			"6" = "cd -6";
			"7" = "cd -7";
			"8" = "cd -8";
			"9" = "cd -9";
			# }}}
		};

		shellInit = ''
			# {{{ completion style settings
			zstyle ':completion:*' use-cache on
			zstyle ':completion:*' cache-path "$comppath"
			zstyle ':completion:*' rehash true
			zstyle ':completion:*' verbose true
			zstyle ':completion:*' insert-tab false
			zstyle ':completion:*' accept-exact '*(N)'
			zstyle ':completion:*' squeeze-slashes true
			zstyle ':completion:*:*:*:*:*' menu select
			zstyle ':completion:*:match:*' original only
			zstyle ':completion:*:-command-:*:' verbose false
			zstyle ':completion::complete:*' gain-privileges 1
			zstyle ':completion:*:manuals.*' insert-sections true
			zstyle ':completion:*:manuals' separate-sections true
			zstyle ':completion:*' completer _complete _match _approximate _ignored
			zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
			zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
			zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
			zstyle ':completion:*:options' list-colors '=^(-- *)=34'
			zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=36=0=01'

			# format
			zstyle ':completion:*' group-name ""
			zstyle ':completion:*:matches' group 'yes'
			zstyle ':completion:*:options' description 'yes'
			zstyle ':completion:*:options' auto-description '%d'
			zstyle ':completion:*:default' list-prompt '%K{4}%F{0}%B %M matches %k%f%b'
			zstyle ':completion:*' format '%K{2}%F{0}%B %d %k%f%b'
			zstyle ':completion:*:messages' format '%K{5}%F{0}%B %d %k%f%b'
			zstyle ':completion:*:descriptions' format '%K{0}%B %d %k%b'
			zstyle ':completion:*:warnings' format '%K{1}%F{0}%B %d %k%f%b'
			zstyle ':completion:*:corrections' format '%K{6}%F{0}%B %d %k%f%b'

			# {{{ completors
			zstyle ':completion:*:functions' ignored-patterns '(prompt*|_*|*precmd*|*preexec*)'
			zstyle ':completion::*:(-command-|export):*' fake-parameters ''${''${''${_comps[(I)-value-*]#*,}%%,*}:#-*-}
			zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
			zstyle ':completion:*:processes-names' command 'ps c -u ''${USER} -o command | uniq'
			zstyle ':completion:*:(vim|nvim|vi|nano|micro|emacs|neovide):*' ignored-patterns '*.(wav|mp3|flac|ogg|mp4|mov|avi|mkv|webm|iso|so|o|7z|zip|tar|gz|bz2|rar|deb|pkg|gzip|pdf|png|jpeg|jpg|jfif|gif)'
			zstyle ':completion:*:ne:*' ignored-patterns '^(*.norg)'
			zstyle ':completion:*:oe:*' ignored-patterns '^(*.org)'
			zstyle ':completion:*:(sy|sioyek|za|zathura):*' ignored-patterns '^(*.(pdf|epub|mobi))'

			# hostnames and addresses
			zstyle ':completion:*:ssh:*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
			zstyle ':completion:*:ssh:*' group-order users hosts-domain hosts-host users hosts-ipaddr
			zstyle ':completion:*:(scp|rsync):*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
			zstyle ':completion:*:(scp|rsync):*' group-order users files all-files hosts-domain hosts-host hosts-ipaddr
			zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost
			zstyle ':completion:*:(ssh|scp|rsync):*:hosts-domain' ignored-patterns '<->.<->.<->.<->' '^[-[:alnum:]]##(.[-[:alnum:]]##)##' '*@*'
			zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*'

			# beware: a lot of escaped dollar signs
			zstyle -e ':completion:*:hosts' hosts 'reply=( ''${=''${=''${=''${''${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) 2>/dev/null)"}%%[#| ]*}//\]:[0-9]*/ }//,/ }//\[/ } ''${=''${(f)"$(cat /etc/hosts(|)(N) <<(ypcat hosts 2>/dev/null))"}%%\#*} ''${=''${''${''${''${(@M)''${(f)"$(cat ~/.ssh/config 2>/dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}})'
			# }}}
			# }}}

			# keybinds
			bindkey -v # vi mode
			bindkey -- '^ ' forward-char # accept autosuggestion

			# {{{ better history navigation using beginning-search
			autoload -U up-line-or-beginning-search
			autoload -U down-line-or-beginning-search
			zle -N up-line-or-beginning-search
			zle -N down-line-or-beginning-search

			bindkey -- '^k'   up-line-or-beginning-search
			bindkey -- '^j'   down-line-or-beginning-search
			bindkey -- '^p'   up-line-or-beginning-search
			bindkey -- '^n'   down-line-or-beginning-search
			bindkey -- 'OA' up-line-or-beginning-search
			bindkey -- 'OB' down-line-or-beginning-search
			bindkey -- '^[^M' self-insert-unmeta
			bindkey -- '^[[Z' reverse-menu-complete
			bindkey -s '^z'   'fg^M'
			# }}}
		'';

		# {{{ plugins
		autosuggestions = {
			enable = true;
			strategy = [
				"completion"
				"history"
			];
		};

		syntaxHighlighting = {
			enable = true;
			highlighters = [
				"main"
				"brackets"
			];
		};
		# }}}
	};
	# }}}

	# {{{ user-specific configuration
	hm.programs.zsh = {
		enable = true;
		defaultKeymap = "viins";
		history.path = "${config.hm.xdg.dataHome}/zsh/zsh_history";

		localVariables = {
			# prompt for regular user
			PS1 = mkPS1 "4";
			PS2 = mkPS2 "4";
			PS3 = mkPS3 "4";
			RPROMPT = rprompt;
			ZLE_RPROMPT_INDENT = "0";
		};

		shellAliases = {
			ec = "fork emacsclient -a '' -c";
			tdy = "ec $(date +%Y.%m.%d).org";
		};

		initExtra = ''
			fork() {
				"$@" > /dev/null 2>&1 & disown;
			}
			launch() {
				fork "$@"; exit;
			}
			bindkey -s '^f' '^[Ifork ^M'
			bindkey -s '^g' '^[Ilaunch ^M'
		'';
	};
	# }}}

	# direnv
	hm.programs.direnv = {
		enable = true;
		enableZshIntegration = true;
		config = {
			global.hide_env_diff = true;
		};

		nix-direnv.enable = true;
	};

	# zoxide
	hm.programs.zoxide = {
		enable = true;
		enableZshIntegration = true;
	};

	# sudo messages & preserve SSH variables across sudo boundaries
	security.sudo.extraConfig = ''
		Defaults passprompt="[sudo] authenticating as %p: "
		Defaults badpass_message="[sudo] incorrect password"
		Defaults authfail_message="[sudo] %d incorrect attempts"

		Defaults env_keep += "SSH_TTY SSH_CONNECTION SSH_CLIENT"
	'';
}
