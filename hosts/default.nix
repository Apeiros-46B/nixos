inputs:

let
	lib = inputs.nixpkgs.lib;
	# {{{ host constructor
	mkHost = hostname: { type, theme, system, stateVersion, globals }: {
		name = hostname;
		value = lib.nixosSystem {
			inherit system;
			specialArgs = lib.attrsets.recursiveUpdate
				(import ../config/util { inherit inputs hostname type; })
				{
					inherit inputs globals system;
					theme = import (../config/themes + ("/" + theme) + ".nix");
				};
			modules = [
				../modules
				../config/common           # common config
				(../config + ("/" + type)) # type-specific config
				(./. + ("/" + hostname))   # host-specific config
				{
					system.stateVersion  = stateVersion;
					hm.home.stateVersion = stateVersion;
				}
			];
		};
	};
	# }}}
in with builtins; rec {
	nixosConfigurations = listToAttrs (import ./hosts.nix mkHost);
	homeConfigurations = mapAttrs (_: v: v.config.hm.home) nixosConfigurations;
}
