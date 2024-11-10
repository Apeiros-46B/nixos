{ inputs, pkgs, ... }:

{
	imports = [
		inputs.sops-nix.nixosModules.sops
	];

	environment.systemPackages = with pkgs; [ sops age ssh-to-age ];

	sops.age = {
		sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
		keyFile = "/root/.config/sops/age/keys.txt";
		generateKey = true;
	};
}
