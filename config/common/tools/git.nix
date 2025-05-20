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
				s  = "status";
				sp = "stash pop";
				st = "stash";
				sw = "switch";
				u  = "reset --soft HEAD^";
			};

			core.pager = "delta";
			interactive.diffFilter = "delta --color-only";
			delta = {
				dark = theme.dark;
				syntax-theme = "none"; # TODO: make a delta theme that matches the system
				minus-emph-style = "red #${theme.colors.bgRed} bold strike";
				minus-style = "red #${theme.colors.bgRed}";
				plus-emph-style = "green #${theme.colors.bgGreen} bold";
				plus-style = "green #${theme.colors.bgGreen}";
			};
		};
	};

	hm.programs.gh.enable = true;
}
