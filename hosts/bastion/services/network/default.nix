{ config, ... }:

{
	imports = [
		./tailscale.nix
		./pihole.nix
	];

	# TODO: at some point it's probably worth considering if my.services.* should take
	# `secrets = { file = ./Secrets.yaml, value = "frp-token" }` for more decoupling.
	# then the module can properly set restartUnits etc.
	sops.secrets.frp-token = {
		sopsFile = ./Secrets.yaml;
		owner = "root";
		group = "root";
		mode = "0400";
	};

	sops.secrets.vultr-api-key = {
		sopsFile = ./Secrets.yaml;
		owner = "grafana";
		group = "grafana";
		mode = "0400";
		restartUnits = [ "grafana.service" ];
	};

	my.services.rproxy = {
		enable = true;
		tokenPath = config.sops.secrets.frp-token.path;
	};

	services.grafana.provision.datasources.settings.datasources = [{
		name = "Infinity - Vultr";
		type = "yesoreyeram-infinity-datasource";
		uid = "infinity-vultr";
		editable = false;
		jsonData = {
			allowedHosts = [ "https://api.vultr.com" ];
			httpHeaderName1 = "Authorization";
		};
		secureJsonData = {
			httpHeaderValue1 = "Bearer $__file{${config.sops.secrets.vultr-api-key.path}}";
		};
	}];
}
