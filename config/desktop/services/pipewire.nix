{ pkgs, ... }:

{
	# disable ALSA and pulse
	services.pulseaudio.enable = false;

	services.pipewire = {
		enable = true;

		# compatibility
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
		jack.enable = true;
	};

	environment.systemPackages = with pkgs; [
		pavucontrol
		pulseaudio # for pactl
	];
}
