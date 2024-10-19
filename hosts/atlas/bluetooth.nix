{ pkgs, ... }:

{
	hardware.bluetooth = {
		enable = true;
		powerOnBoot = false;

		# report battery level to upower
		settings.General.Experimental = true;
	};

	services.blueman.enable = true;

	my.home.packages = [
		(with pkgs; writeShellScriptBin "blue" ''
			case "$1" in
				on)
					bluetooth on
					bluetoothctl power on
					bluetoothctl agent on
					exit 0
					;;
				off) bluetooth off; bluetoothctl power off; exit 0 ;;
				con) act="connect"    ;;
				dis) act="disconnect" ;;
				*)   exit 1 ;;
			esac
			[ "$2" ] || exit 1
			bluetoothctl "$act" "$(cat "$HOME/.config/bluetooth/$2")"
		'')
	];

	# support audio
	# TODO is this needed?
	# services.pipewire.wireplumber.extraConfig."10-bluez" = {
	# 	"monitor.bluez.properties" = {
	# 		"bluez5.enable-sbc-xq" = true;
	# 		"bluez5.enable-msbc" = true;
	# 		"bluez5.enable-hw-volume" = true;
	# 		"bluez5.roles" = [
	# 			"hsp_hs"
	# 			"hsp_ag"
	# 			"hfp_hf"
	# 			"hfp_ag"
	# 		];
	# 	};
	# };
}
