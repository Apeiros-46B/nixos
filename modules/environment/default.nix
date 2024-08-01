{ ... }:

{
	environment.variables = rec {
		EDITOR = "nvim";
		VISUAL = EDITOR;
		LC_COLLATE = "C";
		# CARGO_HOME = "${globals}";
	};
}
