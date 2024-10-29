inputs:

let
	mkHost = hostname: { type, theme, system, stateVersion }:
	# {{{ host constructor
		inputs.nixpkgs.lib.nixosSystem
	{
		inherit system;
		specialArgs = (import ../config/util { inherit inputs hostname; }) // {
			inherit system inputs;
			theme = import (../config/themes + ("/" + theme) + ".nix");
		};
		modules = [
			../config/common           # common config
			(../config + ("/" + type)) # type-specific config
			(./. + ("/" + hostname))   # host-specific config
			{
				system.stateVersion  = stateVersion;
				hm.home.stateVersion = stateVersion;
			}
		];
	};
	# }}}
in rec {
	nixosConfigurations = {
		atlas = mkHost "atlas" {
			type = "desktop";
			theme = "everforest";
			system = "x86_64-linux";
			stateVersion = "23.11";
		};
	};
	homeConfigurations =
		builtins.mapAttrs (_: v: v.config.hm.home) nixosConfigurations;
}
