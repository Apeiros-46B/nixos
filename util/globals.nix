# shared globals used on every system
rec {
	uid = 1000;
	user = "apeiros";
	name = "Apeiros";
	home = "/home/${user}";
	gitName = "Apeiros-46B";
	gitEmail = "Apeiros-46B@users.noreply.github.com";

	dir = rec {
		cfg  = "${home}/.config";
		desk = "${home}/desk";
		dl   = "${home}/dl";
		doc  = "${home}/doc";
		mus  = "${home}/mus";
		pic  = "${home}/pic";
		pub  = "${home}/pub";
		temp = "${home}/tmp";
		tmpl = "${home}/tmpl";
		vid  = "${home}/vid";

		nix  = "${cfg}/nixos";
	};

	# host-specific (arguments to mkHost):
	# hostname = "";
	# stateVersion = "";
}
