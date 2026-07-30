# DECO*27 mentioned
{ lib, config, globals, ... }:

let
	grafanaPort = 3000;
	grafanaDomain = "obs.${globals.net.tsDomain}";
	prometheusPort = 9090;
	prometheusDomain = "prom.${globals.net.tsDomain}";
	nodeExporterPort = 9100;
	zfsExporterPort = 9101;
	smartctlExporterPort = 9102;
in {
	my.services.rproxy.tsDomains = {
		${grafanaDomain} = grafanaPort;
		${prometheusDomain} = prometheusPort;
	};

	sops.secrets.grafana-secret-key = {
		sopsFile = ./Secrets.yaml;
		owner = "grafana";
		group = "grafana";
		mode = "0400";
	};

	services.grafana = {
		enable = true;
		settings = {
			security.secret_key = "$__file{${config.sops.secrets.grafana-secret-key.path}}";
			auth = {
				login_maximum_inactive_lifetime_duration = "14d";
				login_maximum_lifetime_duration = "30d";
				token_rotation_interval_minutes = 720;
			};
			server = {
				http_addr = "0.0.0.0";
				http_port = grafanaPort;
				root_url = "http://${grafanaDomain}/";
				domain = grafanaDomain;
				enforce_domain = false;
				enable_gzip = true;
			};
			analytics.reporting_enabled = false;
		};
		provision = {
			enable = true;
			datasources.settings.datasources = [
				{
					name = "Prometheus";
					type = "prometheus";
					url = "http://127.0.0.1:${toString prometheusPort}";
					isDefault = true;
					editable = false;
				}
			];
		};
	};

	services.prometheus = {
		enable = true;
		port = prometheusPort;
		globalConfig.scrape_interval = "10s";
		scrapeConfigs = [
			{
				job_name = "node";
				static_configs = [{ targets = [ "localhost:${toString nodeExporterPort}" ]; }];
			}
			{
				job_name = "zfs";
				static_configs = [{ targets = [ "localhost:${toString zfsExporterPort}" ]; }];
			}
			{
				job_name = "smartctl";
				static_configs = [{ targets = [ "localhost:${toString smartctlExporterPort}" ]; }];
			}
		];
	};

	services.prometheus.exporters.node = {
		enable = true;
		port = nodeExporterPort;
		listenAddress = "127.0.0.1";
		enabledCollectors = [
			"cpu"
			"cpufreq"
			"loadavg"
			"stat"
			"meminfo"
			"diskstats"
			"filesystem"
			"zfs"
			"netdev"
			"netstat"
			"sockstat"
			"hwmon"
			"thermal_zone"
			"nvme"
			"pressure"
			"systemd"
		];
		extraFlags = [
			"--collector.disable-defaults"
			"--collector.filesystem.mount-points-exclude=^/(dev|proc|sys|mnt/docker/.+)($|/)"
		];
	};

	services.prometheus.exporters.zfs = {
		enable = true;
		port = zfsExporterPort;
		listenAddress = "127.0.0.1";
	};

	# TODO: this doesn't work, fails with permission issue
	services.prometheus.exporters.smartctl = {
		enable = false;
		port = smartctlExporterPort;
		listenAddress = "127.0.0.1";
	};
}
