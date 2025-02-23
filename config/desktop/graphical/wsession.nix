{ inputs, config, pkgs, theme, ... }:

{
	imports = [
		inputs.niri.nixosModules.niri
	];

	# TODO: can we change this to hm.home.packages?
	environment.systemPackages = with pkgs; [
		xwayland-satellite
		swww
		foot # TMP, move out to separate file
		swaylock
		imv # TMP, move out to separate file
	];

	hm.home.packages = with pkgs; [ grim slurp wl-clipboard wl-clip-persist ];

	hm.programs.fuzzel = {
		enable = true;
		settings = {
			main = {
				font = "${theme.font.mono2}:size=13";
				terminal = "${pkgs.foot}/bin/footclient";

				use-bold = true;
				show-actions = true;
				icons-enabled = false;

				width = 50;
				lines = 25;
				tabs = 2;
				horizontal-pad = 40;
				vertical-pad = 40;
			};
			colors = with builtins.mapAttrs (k: v: "${v}ff") theme.colors; {
				background = bg2;
				text = fg1;
				prompt = orange;
				placeholder = fg2;
				input = fg1;
				match = green;
				selection = green;
				selection-text = bg3;
				selection-match = bg1;
			};
		};
	};

	hm.services.mako = with theme.colorsHash; {
		enable = true;
		defaultTimeout = 5000;
		borderSize = 0;
		borderRadius = 0;
		padding = "16";
		margin = "24";
		maxIconSize = 48;
		width = 400;
		textColor = fg1;
		progressColor = green;
		backgroundColor = bg2;
	};

	programs.niri = {
		enable = true;
		package = pkgs.niri-unstable;
	};

	hm.programs.niri.settings = {
		input = {
			keyboard = {
				repeat-delay = 350;
				repeat-rate = 75;
			};
			touchpad = {
				tap = true;
				accel-speed = 0.8;
				accel-profile = "flat";
				tap-button-map = "left-right-middle";
				click-method = "clickfinger";
			};
			mouse = {
				accel-speed = 0.0;
				accel-profile = "flat";
			};
			trackpoint = {
				accel-speed = 0.2;
				accel-profile = "flat";
				scroll-method = "on-button-down";
				scroll-button = 274;
			};
			focus-follows-mouse.max-scroll-amount = "0%";
		};
		switch-events.lid-close.action.spawn = "swaylock";
		binds = with config.hm.lib.niri.actions; let
			fuzzel = args: [ "fuzzel" "-p" "" ] ++ args;
			sh = spawn "sh" "-c";
			no-repeat = action: { repeat = false; inherit action; };
			allow-when-locked = action: { allow-when-locked = true; inherit action; };
		in {
			"Mod+Escape".action = toggle-keyboard-shortcuts-inhibit;
			"Mod+Shift+B".action = show-hotkey-overlay;
			"Ctrl+Alt+Delete".action = quit;
			"Ctrl+Shift+Delete".action = power-off-monitors;
			"Ctrl+Shift+Escape" = no-repeat (spawn "footclient" "-e" "btop");

			"Mod+Return" = no-repeat (spawn "footclient");
			"Mod+Shift+S" = no-repeat (sh ''grim -g "$(slurp)" - | wl-copy'');
			"Mod+Ctrl+Shift+S" = no-repeat (sh ''
				file="$(${pkgs.coreutils}/bin/mktemp)"
				grim -g "$(slurp)" "$file" && imv "$file"; rm "$file"
			'');
			"Mod+Space" = no-repeat (spawn (fuzzel []));
			"Mod+Shift+Space" = no-repeat (spawn (fuzzel ["--list-executables-in-path"]));
			"Mod+Shift+Q".action = spawn "swaylock";
			"Mod+0" = allow-when-locked (
				sh ''notify-send "$(date '+%Y/%m/%d:%u -> %H:%M:%S')" \
				                 "$(acpi | grep 'Battery 0')"''
			);

			"XF86AudioRaiseVolume" = allow-when-locked (
				spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"
			);
			"XF86AudioLowerVolume" = allow-when-locked (
				spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"
			);
			"XF86AudioMute" = allow-when-locked (
				spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"
			);
			"XF86AudioMicMute" = allow-when-locked (
				spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"
			);
			"XF86MonBrightnessUp" = allow-when-locked (spawn "brightnessctl" "set" "5%+");
			"XF86MonBrightnessDown" = allow-when-locked (spawn "brightnessctl" "set" "5%-");

			"Mod+C" = no-repeat (close-window);
			"Mod+F".action = fullscreen-window;
			"Mod+Shift+F".action = toggle-window-floating;

			"Mod+H".action = focus-column-left;
			"Mod+J".action = focus-window-or-workspace-down;
			"Mod+K".action = focus-window-or-workspace-up;
			"Mod+L".action = focus-column-right;
			"Mod+Shift+H".action = move-column-left;
			"Mod+Shift+J".action = move-window-down-or-to-workspace-down;
			"Mod+Shift+K".action = move-window-up-or-to-workspace-up;
			"Mod+Shift+L".action = move-column-right;
			"Mod+G".action = focus-column-first;
			"Mod+Shift+G".action = focus-column-last;
			"Mod+Ctrl+G".action = move-column-to-first;
			"Mod+Ctrl+Shift+G".action = move-column-to-last;
			"Mod+Shift+C".action = center-column;
			"Mod+M".action = maximize-column;
			"Mod+Y".action = set-column-width "-10%";
			"Mod+O".action = set-column-width "+10%";
			"Mod+P".action = consume-window-into-column;
			"Mod+Shift+P".action = expel-window-from-column;
			"Mod+Shift+Y".action = consume-or-expel-window-left;
			"Mod+Shift+O".action = consume-or-expel-window-right;
			"Mod+R".action = switch-preset-column-width;
			"Mod+Q".action = switch-preset-window-height;
			"Mod+T".action = toggle-column-tabbed-display;

			"Mod+1".action = focus-workspace 1;
			"Mod+2".action = focus-workspace 2;
			"Mod+3".action = focus-workspace 3;
			"Mod+4".action = focus-workspace 4;
			"Mod+5".action = focus-workspace 5;
			"Mod+6".action = focus-workspace 6;
			"Mod+7".action = focus-workspace 7;
			"Mod+8".action = focus-workspace 8;
			"Mod+Shift+1".action = move-column-to-workspace 1;
			"Mod+Shift+2".action = move-column-to-workspace 2;
			"Mod+Shift+3".action = move-column-to-workspace 3;
			"Mod+Shift+4".action = move-column-to-workspace 4;
			"Mod+Shift+5".action = move-column-to-workspace 5;
			"Mod+Shift+6".action = move-column-to-workspace 6;
			"Mod+Shift+7".action = move-column-to-workspace 7;
			"Mod+Shift+8".action = move-column-to-workspace 8;
			"Mod+Tab".action = focus-workspace-previous;
			"Mod+U".action = focus-workspace-down;
			"Mod+I".action = focus-workspace-up;
			"Mod+Shift+U".action = move-column-to-workspace-down;
			"Mod+Shift+I".action = move-column-to-workspace-up;
			"Mod+Ctrl+U".action = move-workspace-down;
			"Mod+Ctrl+I".action = move-workspace-up;

			"Mod+Ctrl+H".action = focus-monitor-left;
			"Mod+Ctrl+J".action = focus-monitor-down;
			"Mod+Ctrl+K".action = focus-monitor-up;
			"Mod+Ctrl+L".action = focus-monitor-right;
			"Mod+Ctrl+Shift+H".action = move-column-to-monitor-left;
			"Mod+Ctrl+Shift+J".action = move-column-to-monitor-down;
			"Mod+Ctrl+Shift+K".action = move-column-to-monitor-up;
			"Mod+Ctrl+Shift+L".action = move-column-to-monitor-right;
		};
		window-rules = [
			{
				matches = [{ app-id = "^brave-browser$"; }];
				open-maximized = true;
			}
			{
				matches = [{ app-id = "^imv$"; }];
				open-floating = true;
			}
		];
		layout = {
			gaps = 8;
			focus-ring.enable = false;
			border.enable = false;
			insert-hint = {
				enable = true;
				display.color = "${theme.colorsHash.blue}33";
			};
			# tab-indicator = {
			# 	enable = true;
			# 	gap = 0;
			# 	gaps-between-tabs = 2;
			# 	width = 8;
			# 	position = "top";
			# 	active-color = "${theme.colorsHash.green}";
			# 	inactive-color = "${theme.colorsHash.bg3}";
			# };
			default-column-width.proportion = 1. / 2.;
			preset-column-widths = [
				{ proportion = 1. / 3.; }
				{ proportion = 1. / 2.; }
				{ proportion = 2. / 3.; }
			];
			preset-window-heights = [
				{ proportion = 1. / 3.; }
				{ proportion = 1. / 2.; }
				{ proportion = 1.; }
			];
		};
		# TODO: get this working on multi monitor?
		workspaces = {
			"1".name = "sch-www";
			"2".name = "sch";
			"3".name = "dev-www";
			"4".name = "dev";
			"5".name = "adm";
			"6".name = "tmp";
			"7".name = "www";
		};
		cursor = {
			theme = config.hm.home.pointerCursor.name;
			size = config.hm.home.pointerCursor.size;
			hide-when-typing = false;
		};
		animations.slowdown = 0.8;
		prefer-no-csd = true;
		spawn-at-startup = [
			{ command = [ "swww-daemon" ]; }
			{ command = [ "xwayland-satellite" ]; }
			{ command = [ "foot" "--server" ]; }
			{ command = [ "wl-clip-persist" "--clipboard" "regular" ]; }
		];
	};

	# hm.home.pointerCursor = {
	# 	name = "phinger-cursors-light";
	# 	package = pkgs.phinger-cursors;
	# 	size = 32;
	# 	gtk.enable = true;
	# };
}
