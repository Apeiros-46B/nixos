{ lib, pkgs, ... }:

{
	environment.systemPackages = [ pkgs.cloudflare-warp ];

	users.users.warp = {
		isSystemUser = true;
		group = "warp";
		description = "Cloudflare Warp user";
		home = "/var/lib/cloudflare-warp";
	};
	users.groups.warp = {};

	services.resolved.settings.Resolve = {
		ResolveUnicastSingleLabel = true;
	};

	systemd = {
		packages = [
			(pkgs.cloudflare-warp.overrideAttrs (old: {
				postInstall =
					let
						path = lib.makeBinPath (with pkgs; [ nftables lsof iproute2 ]);
					in
						''
							wrapProgram $out/bin/warp-svc --prefix PATH : ${path}
						'';
			}))
		];

		services.warp-svc = {
			after = ["network-online.target" "systemd-resolved.service"];
			wants = ["network-online.target"];
			wantedBy = ["multi-user.target"];

			serviceConfig = {
				StateDirectory = "cloudflare-warp";
				# User = "warp";
				# Umask = "0077";

				LockPersonality = true;
				PrivateMounts = true;
				PrivateTmp = true;
				ProtectControlGroups = true;
				ProtectHostname = true;
				protectKernelLogs = true;
				ProtectKernelModules = true;
				ProtectKernelTunables = true;
				ProtectProc = "invisible";

				ProtectSystem = true;
				RestrictNamespaces = true;
				RestrictRealtime = true;
			};
		};
	};
}
