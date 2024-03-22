# kludge to allow impure linking
{ lib, globals }:

let
	capFirst = str: lib.strings.toUpper (builtins.substring 0 1 str)
									+ builtins.substring 1 (-1) str;
in {
	linkDots = name: opts: lib.mkMerge [
		opts
		({
			my = { config, ... }:
				let
					target = "${globals.dir.nix}/dots/${name}";
				in
			{
				home.activation.${"link" + capFirst name}
					= config.lib.dag.entryAfter [ "writeBoundary" ]
				''
					ln -sf '${target}' '${globals.dir.cfg}/${name}'
					old_link='${target}/${name}'
					[ -L "$old_link" ] && rm "$old_link"
				'';
			};
		})
	];
}
