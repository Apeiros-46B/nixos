{ config, pkgs, globals, ... }:

let
	# make prompts with the specified accent color
	mkPS1 = color: "%F{0}%B%(0?.%K{${color}} .%K{1} )%(1j.& .)%K{8}%f %~ %k%b ";
	mkPS2 = color: "%K{${color}} %K{8}%B + %b%k ";
	mkPS3 = color: "%K{${color}} %K{8}%B > %b%k ";
in {
	# make zsh the default shell system-wide
	users.defaultUserShell = pkgs.zsh;
	environment.shells = [ pkgs.zsh ];

	# {{{ system-wide shell aliases
	environment.shellAliases =
		let
			cfg = globals.dir.nix;
			home = globals.home;
			name = globals.hostname;
		in
	{
		c = "clear -x";
		q = "exit";
		s = "sudo ";

		l  = "ls -lAh";
		la = "ls -A";
		cx = "chmod +x";

		# NixOS
		reb   = "sudo nixos-rebuild switch --flake '${cfg}#${name}'";
		upd   = "reb --upgrade";
		hm    = "home-manager";
		hmreb = "home-manager switch --flake '${cfg}#${name}'";
	};
	# }}}

	# {{{ system-wide zsh configuration
	programs.zsh = {
		enable = true;

		# prompt for root user
		promptInit = ''
			PS1='${mkPS1 "5"}'
			PS2='${mkPS2 "5"}'
			PS3='${mkPS3 "5"}'
		'';

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
	};
	# }}}

	# {{{ user-specific configuration
	my.programs.zsh = {
		enable = true;
		defaultKeymap = "viins";

		history.path = "${config.my.xdg.dataHome}/zsh/zsh_history";

		# {{{ aliases
		shellAliases = {
			# source rc
			re = "source ${globals.home}/.zshrc";

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
		};
		# }}}

		localVariables = {
			# prompt for regular user
			PS1 = mkPS1 "4";
			PS2 = mkPS2 "4";
			PS3 = mkPS3 "4";
			ZLE_RPROMPT_INDENT = "0";
		};

		# {{{ plugins
		plugins = [
			{
				name = "zsh-syntax-highlighting";
				src = pkgs.fetchFromGitHub {
					owner = "zsh-users";
					repo = "zsh-syntax-highlighting";
					rev = "e0165eaa730dd0fa321a6a6de74f092fe87630b0";
					sha256 = "4rW2N+ankAH4sA6Sa5mr9IKsdAg7WTgrmyqJ2V1vygQ=";
				};
			}
		];
		# }}}
	};
	# }}}

	# direnv
	my.programs.direnv = {
		enable = true;
		enableZshIntegration = true;
		nix-direnv.enable = true;
	};

	# zoxide
	my.programs.zoxide = {
		enable = true;
		enableZshIntegration = true;
	};
}
