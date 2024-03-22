{ config, globals, ... }:

{
	environment.variables = rec {
		EDITOR = "nvim";
		VISUAL = EDITOR;
		# CARGO_HOME = "${globals}";
	};
}
