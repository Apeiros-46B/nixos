{ lib, pkgs, ... }:

{
	virtualisation.podman = {
		enable = true;
		dockerCompat = true;
	};

	environment.systemPackages = [ pkgs.distrobox ];
	environment.etc."distrobox/distrobox.conf".text = ''
		container_additional_volumes="/nix:/nix:ro /etc/profiles:/etc/profiles:ro /etc/static/profiles:/etc/static/profiles:ro /etc/zshrc:/etc/zshrc:ro /etc/zshenv:/etc/zshenv:ro /etc/zprofile:/etc/zprofile:ro /etc/zinputrc:/etc/zinputrc:ro"
	'';

	# inject Nix-installed tools from host into guest
	hm.home.file.".local/share/distrobox-tools".source = pkgs.buildEnv {
		name = "distrobox-tools";
		paths = with pkgs; [
			(writeShellScriptBin "distrobox" ''
				echo "error: you are already inside the distrobox container" >&2
				exit 1
			'')
			uv
		];
	};

	# make some of the original guest binaries take priority over system Nix binaries
	hm.home.file.".local/share/distrobox-mask".source = pkgs.runCommand "distrobox-mask" {} ''
		mkdir -p $out/bin
		for bin in sudo ssh; do
			ln -s "/usr/bin/$bin" "$out/bin/$bin"
		done
	'';

	hm.programs.zsh = {
		# compinit -u suppresses insecure directories prompt
		completionInit = "autoload -U compinit && compinit -u";
		initContent = lib.mkBefore ''
			if [ -n "$CONTAINER_ID" ]; then
				export CONTAINER_NATIVE_PATH="$PATH"

				# clobbers PATH, needs restoration afterwards
				[ -f /etc/zshenv ] && source /etc/zshenv
				export PATH="$CONTAINER_NATIVE_PATH"
				export PATH="/etc/profiles/per-user/$USER/bin:$PATH"
				export PATH="/nix/var/nix/profiles/default/bin:$PATH"
				export PATH="/nix/var/nix/profiles/system/sw/bin:$PATH"
				export PATH="$HOME/.nix-profile/bin:$PATH"
				export PATH="$HOME/.local/share/distrobox-mask/bin:$PATH"
				export PATH="$HOME/.local/share/distrobox-tools/bin:$PATH"

				alias compinit="compinit -u"
				[ -f /etc/zprofile ] && source /etc/zprofile
				[ -f /etc/zshrc ] && source /etc/zshrc
				unalias compinit
			fi
		'';
	};
}
