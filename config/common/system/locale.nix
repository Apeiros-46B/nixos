{ ... }:

{
	time.timeZone = "America/Vancouver";
	i18n.defaultLocale = "en_US.UTF-8";
	environment.variables.LC_COLLATE = "C";

	services.timesyncd.enable = false;
	services.chrony = {
		enable = true;
		servers = [
			"time.nrc.ca"
			"0.nixos.pool.ntp.org"
			"1.nixos.pool.ntp.org"
		];
	};
}
