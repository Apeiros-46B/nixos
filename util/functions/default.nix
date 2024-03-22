{ inputs, globals }:

let
	lib = inputs.nixpkgs.lib;
in
	import ./hex.nix { inherit lib globals; } //
	import ./ln.nix { inherit lib globals; } //
{
	dpi = config: x: x * config.services.xserver.dpi / 96;

	stripTabs = with builtins; text:
		let
			shouldStripTab = lns: all (ln: (ln == "") || (lib.hasPrefix "	" ln)) lns;
			stripTab = lns: map (ln: lib.removePrefix "	" ln) lns;
			stripTabs = lns:
				if (shouldStripTab lns)
				then (stripTabs (stripTab lns))
				else lns;
		in
			concatStringsSep "\n" (stripTabs (lib.splitString "\n" text));
}
