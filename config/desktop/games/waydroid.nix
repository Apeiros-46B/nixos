{ ... }:

{
	virtualisation.waydroid.enable = true;
	systemd.tmpfiles.settings."10-waydroid"."/var/lib/waydroid/waydroid_base.prop".f = {
		user = "root";
		group = "root";
		mode = "0666";
		argument = ''
			ro.hardware.gralloc=default
			ro.hardware.egl=swiftshader
			sys.use_memfd=true
		'';
	};
}
