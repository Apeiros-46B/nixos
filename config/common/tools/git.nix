{ pkgs, globals, ... }:

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
			};

			core.pager = "delta";
			interactive.diffFilter = "delta --color-only";
		};
	};

	hm.programs.gh.enable = true;
}
