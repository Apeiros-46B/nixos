# kludge to allow impure linking
{ lib, globals }:

let
	capFirst = str: lib.strings.toUpper (builtins.substring 0 1 str)
	              + builtins.substring 1 (-1) str;
in {
	linkImpure = name: opts: lib.mkMerge [
		opts
		({
			hm = { config, ... }:
				let
					target = "${globals.dir.nix}/impure/${name}";
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
	linkAwesomeLib = pkg: opts: lib.mkMerge [
		opts
		({
			hm = { config, ... }: {
				# link lib so lua ls can provide diagnostics for the lib
				home.activation.linkAwesomeLib
					= config.lib.dag.entryAfter [ "writeBoundary" ]
				''
					ln -sf '${pkg}/share/awesome/lib' '${globals.dir.cfg}/awesome_lib'
				'';
			};
		})
	];
}
