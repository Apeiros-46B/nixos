{ hostname, type }:

rec {
	inherit hostname;
	hostType = type;

	uid = 1000;
	user = "apeiros";
	name = "Apeiros";
	home = "/home/${user}";

	# TODO: put under a new "git" attrset
	gitName = "Apeiros-46B";
	gitEmail = "Apeiros-46B@users.noreply.github.com";

	discordUid = "443604304264429578";

	net = {
		pubDomain = "apeiros.xyz";
		tsDomain = "ts.apeiros.xyz";
		tsRange = "100.64.0.0/10";
		lanRange = "10.0.0.0/8";
	};

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
		vm   = "${home}/vm";
		nix  = "${cfg}/nixos";
	};
}
