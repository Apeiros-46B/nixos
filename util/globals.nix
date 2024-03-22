# shared globals used on every system
rec {
	user = "apeiros";
	name = "Apeiros";
	home = "/home/${user}";
	gitEmail = "Apeiros-46B@users.noreply.github.com";

	dir = rec {
		cfg  = "${home}/.config";
		desk = "${home}/desk";
		dl   = "${home}/dl";
		doc  = "${home}/doc";
		mus  = "${home}/mus";
		pic  = "${home}/pic";
		pub  = "${home}/pub";
		tmpl = "${home}/tmpl";
		vid  = "${home}/vid";

		nix  = "${cfg}/nixos";
	};

	# host-specific (arguments to mkHost):
	# hostname = "";
	# stateVersion = "";
}
