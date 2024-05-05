{ globals, ... }:

{
	my.programs.git = {
		enable = true;

		userName = globals.gitName;
		userEmail = globals.gitEmail;
		
		aliases = {
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
		
		delta = {
			enable = true;
			# TODO: customize colors
		};
		
		extraConfig = {
			init.defaultBranch = "main";
			pull.rebase = false;
		};
	};
		
	my.programs.gh = {
		enable = true;
		gitCredentialHelper = {
			enable = true;
			hosts = [ "https://github.com" "https://gist.github.com" ];
		};
	};
}
