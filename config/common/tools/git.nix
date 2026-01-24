{ pkgs, globals, theme, ... }:

{
	environment.systemPackages = [ pkgs.delta ];

	programs.git = {
		enable = true;

		config = {
			user = {
				name  = globals.gitName;
				email = globals.gitEmail;
			};
			init.defaultBranch = "main";
			pull.rebase = false;
			alias = {
				a  = "add";
				aa = "add --all";
				ap = "add --patch";
				aP = "apply";
				b  = "branch";
				c  = "commit";
				cm = "commit --message";
				ca = "commit --amend";
				cl = "clone";
				d  = "diff";
				ds = "diff --staged";
				j  = "pull";
				k  = "push";
				l  = "log";
				m  = "submodule";
				ma = "submodule add";
				mi = "submodule update --init --recursive";
				mu = "submodule update";
				r  = "restore --staged";
				R  = "restore"; # capitalized to avoid accidents
				Rs = "reset";
				RS = "reset --hard";
				s  = "status --short --branch";
				sl = "status";
				sp = "stash pop";
				st = "stash";
				sw = "switch";
				u  = "reset --soft HEAD^";
			};

			core.pager = "delta";
			interactive.diffFilter = "delta --color-only";
			delta = {
				dark = theme.dark;
				navigate = "true";
				file-style = "cyan bold";
				file-decoration-style = "omit";
				minus-emph-style = "black bold red";
				minus-style = "red 244"; # TODO: hardcoded 256colors should be defined by the theme
				plus-emph-style = "black bold green";
				plus-style = "green 247";
				hunk-header-decoration-style = "white";
				hunk-header-file-style = "white";
				hunk-header-line-number-style = "blue";
				hunk-header-style = "line-number white bold";
				syntax-theme = "none";
			};
		};
	};

	hm.programs.gh.enable = true;
}
