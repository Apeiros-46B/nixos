{ ... }:

{
	services.libinput = {
		enable = true;
		mouse = {
			accelSpeed = "0.0";
			accelProfile = "flat";
			middleEmulation = false;
		};
		touchpad = {
			accelSpeed = "0.8";
			accelProfile = "flat";
			middleEmulation = false;
			tappingDragLock = false;
			tappingButtonMap = "lrm";
			clickMethod = "clickfinger";
		};
	};

	environment.etc."libinput/local-overrides.quirks".text = ''
		[No Debounce]
		MatchUdevType=mouse
		MatchName=*
		ModelBouncingKeys=1
	'';
}
