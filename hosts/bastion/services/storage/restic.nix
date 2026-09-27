{ config, lib, pkgs, ... }:

let
	datasets = map lib.strings.trim [
		"nixos/media"
		"nixos/nas"
		"nixos/home"
		"nixos/var"
	];

	snapshotCmds = map (name: "${pkgs.zfs}/bin/zfs snapshot -r ${name}@restic") datasets;
	destroyCmds = map (name: "${pkgs.zfs}/bin/zfs destroy -r ${name}@restic") datasets;
	makeCmdLines = cmds: suffix: lib.strings.concatLines (map (c: c + suffix) cmds);

	initScript = pkgs.writeShellScript "restic-zfs-init" ''
		${makeCmdLines destroyCmds " || true"}
		${makeCmdLines snapshotCmds ""}
	'';
	cleanupScript = pkgs.writeShellScript "restic-zfs-cleanup" ''
		${makeCmdLines destroyCmds ""}
	'';
in {
	users.users.restic = {
		isSystemUser = true;
		group = "restic";
	};
	users.groups.restic = {};

	sops.secrets.restic-b2-env = {
		sopsFile = ./Secrets.yaml;
		owner = "restic";
		group = "restic";
		mode = "0400";
	};

	sops.secrets.restic-repo-password = {
		sopsFile = ./Secrets.yaml;
		owner = "restic";
		group = "restic";
		mode = "0400";
	};

	services.restic.backups."b2-media-nas-home-var" = {
		user = "restic";
		initialize = true;
		
		environmentFile = config.sops.secrets.restic-b2-env.path;
		passwordFile = config.sops.secrets.restic-repo-password.path;
		repository = "b2:apeiros-bastion-backups:/";

		timerConfig = {
			OnCalendar = "daily";
			Persistent = true;
		};
		pruneOpts = [
			"--keep-daily 7"
			"--keep-weekly 4"
			"--keep-monthly 12"
		];

		# TODO: need centralized storage constants that associate dataset with mountpoint
		paths = [
			"/mnt/media/.zfs/snapshot/restic"
			"/mnt/nas/.zfs/snapshot/restic"
			"/home/.zfs/snapshot/restic"
			"/var/.zfs/snapshot/restic"
		];
	};

	systemd.services."restic-backups-b2-media-nas-home-var".serviceConfig = {
		# + runs as root, so zfs ops work
		ExecStartPre = lib.mkBefore [ "+${initScript}" ];
		ExecStopPost = lib.mkAfter [ "+${cleanupScript}" ];

		AmbientCapabilities = [ "CAP_DAC_READ_SEARCH" ];
		CapabilityBoundingSet = [ "CAP_DAC_READ_SEARCH" ];

		ProtectSystem = "strict";
		ProtectHome = "read-only";
		PrivateTmp = true;
		
		InaccessiblePaths = [
			"/root"
			"/etc/shadow"
			"/etc/ssh"
		];
	};
}
