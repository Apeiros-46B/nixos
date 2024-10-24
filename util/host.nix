# create a host with flakes and home-manager given a NixOS module to load
{
	name,
	inputs,
	system,
	overlays,
	functions,
	globals,
	theme,
	stateVersion,
	hostDefinition
}:

let lib = inputs.nixpkgs.lib; in
	lib.nixosSystem
{
	inherit system;
	specialArgs = {
		inherit system inputs overlays functions theme;
		globals = globals // { hostname = name; };
	};
	modules = [
		# include the provided host
		hostDefinition

		# include home-manager and sops-nix's flake inputs
		inputs.home-manager.nixosModules.home-manager
		inputs.sops-nix.nixosModules.sops

		# create an alias for home-manager configuration
		(lib.mkAliasOptionModule [ "hm" ] [ "home-manager" "users" globals.user ])

		{
			nix.settings.experimental-features = [ "nix-command" "flakes" ];
			nixpkgs = {
				inherit overlays;
				config.allowUnfree = true;
				hostPlatform = system;
			};

			networking.hostName = name;

			# home-manager
			home-manager = {
				useGlobalPkgs = true;
				useUserPackages = true;
			};

			hm = {
				# TODO: fix news still showing errors despite being slienced?
				news = {
					display = "silent";
					json = lib.mkForce {};
					entries = lib.mkForce [];
				};
				home = {
					username = globals.user;
					homeDirectory = globals.home;
				};

				# self-manage
				programs.home-manager.enable = true;
			};

			system.stateVersion  = stateVersion;
			hm.home.stateVersion = stateVersion;
		}
	];
}
