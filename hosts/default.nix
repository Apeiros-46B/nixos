inputs:

let
	mkHost = hostname: { type, theme, system, stateVersion }:
	# {{{ host constructor
	{
		name = hostname;
		value = inputs.nixpkgs.lib.nixosSystem {
			inherit system;
			specialArgs = (import ../config/util { inherit inputs hostname; }) // {
				inherit system inputs;
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
