{ config, pkgs, globals, ... }:

{
	services.openssh = {
		enable = true;
		allowSFTP = true;
		settings = {
			AllowUsers = [ globals.user ];
			PermitRootLogin = "no";
			PasswordAuthentication = false;
			X11Forwarding = true;
		};
	};

	# send alert to Discord on logins
	sops.secrets.ssh-discord-webhook-url = {
		sopsFile = ./Secrets.yaml;
		owner = "root";
		group = "root";
		mode = "0400";
	};
	# security.pam.services.sshd.text =
	# 	let
	# 		hook = (pkgs.writeShellScriptBin "ssh-discord" ''
	# 			WEBHOOK_URL="$(cat '${config.sops.secrets.ssh-discord-webhook-url.path}')"
	# 			MENTION='<@${globals.discordUid}>'

	# 			case "$PAM_TYPE" in
	# 				open_session)
	# 					PAYLOAD=" { \"content\": \"⚠️ $MENTION user \`$PAM_USER\` logged in to \`$HOSTNAME\` from $PAM_RHOST\" }"
	# 					;;
	# 				close_session)
	# 					PAYLOAD=" { \"content\": \"⚠️ $MENTION user \`$PAM_USER\` logged out of \`$HOSTNAME\` from $PAM_RHOST\" }"
	# 					;;
	# 			esac

	# 			if [ -n "$PAYLOAD" ] ; then
	# 				curl -X POST -H 'Content-Type: application/json' -d "$PAYLOAD" "$WEBHOOK_URL"
	# 			fi
	# 		'');
	# 	in
	# ''
	# 	session	optional	pam_exec.so	${hook}
	# '';
}
