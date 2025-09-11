{ lib, pkgs, globals, ... }:

{
	users.users.${globals.user}.extraGroups = [
		"networkmanager"
	];

	networking = {
		# I only have one network card
		usePredictableInterfaceNames = false;
		useDHCP = lib.mkDefault true;
		networkmanager = {
			enable = true;
			unmanaged = [ "eth0" ];
			wifi = {
				scanRandMacAddress = false;
				powersave = true;
			};
			insertNameservers = [
				"1.1.1.1" # Cloudflare
				"1.0.0.1" # Cloudflare
				"8.8.8.8" # Google
			];
		};
	};

	# GUI frontend
	programs.nm-applet.enable = true;
	environment = {
		systemPackages = [ pkgs.networkmanagerapplet ];
		shellAliases.nmt = "TERM=xterm-old nmtui";
	};

	# power off eth0 on boot
	systemd.services.link-down-eth0 = {
		description = "Set network interface 'eth0' as DOWN";
		wantedBy = [ "multi-user.target" ];
		wants = [ "network-online.target" ];
		after = [ "network-online.target" ];

		serviceConfig = {
			Type = "oneshot";
			ExecStart = "${pkgs.iproute2}/bin/ip link set eth0 down";
		};
	};

	security.pki.certificates = [
		# university wifi
		''
			-----BEGIN CERTIFICATE-----
			MIIDrzCCApegAwIBAgIQCDvgVpBCRrGhdWrJWZHHSjANBgkqhkiG9w0BAQUFADBh
			MQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3
			d3cuZGlnaWNlcnQuY29tMSAwHgYDVQQDExdEaWdpQ2VydCBHbG9iYWwgUm9vdCBD
			QTAeFw0wNjExMTAwMDAwMDBaFw0zMTExMTAwMDAwMDBaMGExCzAJBgNVBAYTAlVT
			MRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5j
			b20xIDAeBgNVBAMTF0RpZ2lDZXJ0IEdsb2JhbCBSb290IENBMIIBIjANBgkqhkiG
			9w0BAQEFAAOCAQ8AMIIBCgKCAQEA4jvhEXLeqKTTo1eqUKKPC3eQyaKl7hLOllsB
			CSDMAZOnTjC3U/dDxGkAV53ijSLdhwZAAIEJzs4bg7/fzTtxRuLWZscFs3YnFo97
			nh6Vfe63SKMI2tavegw5BmV/Sl0fvBf4q77uKNd0f3p4mVmFaG5cIzJLv07A6Fpt
			43C/dxC//AH2hdmoRBBYMql1GNXRor5H4idq9Joz+EkIYIvUX7Q6hL+hqkpMfT7P
			T19sdl6gSzeRntwi5m3OFBqOasv+zbMUZBfHWymeMr/y7vrTC0LUq7dBMtoM1O/4
			gdW7jVg/tRvoSSiicNoxBN33shbyTApOB6jtSj1etX+jkMOvJwIDAQABo2MwYTAO
			BgNVHQ8BAf8EBAMCAYYwDwYDVR0TAQH/BAUwAwEB/zAdBgNVHQ4EFgQUA95QNVbR
			TLtm8KPiGxvDl7I90VUwHwYDVR0jBBgwFoAUA95QNVbRTLtm8KPiGxvDl7I90VUw
			DQYJKoZIhvcNAQEFBQADggEBAMucN6pIExIK+t1EnE9SsPTfrgT1eXkIoyQY/Esr
			hMAtudXH/vTBH1jLuG2cenTnmCmrEbXjcKChzUyImZOMkXDiqw8cvpOp/2PV5Adg
			06O/nVsJ8dWO41P0jmP6P6fbtGbfYmbW0W5BjfIttep3Sp+dWOIrWcBAI+0tKIJF
			PnlUkiaY4IBIqDfv8NZ5YBberOgOzW6sRBc4L0na4UU+Krk2U886UAb3LujEV0ls
			YSEY1QSteDwsOoBrp+uvFRTp2InBuThs4pFsiv9kuXclVzDAGySj4dzp30d8tbQk
			CAUw7C29C79Fv1C5qfPrmAESrciIxpg0X40KPMbp1ZWVbd4=
			-----END CERTIFICATE-----
		''
	];
}
