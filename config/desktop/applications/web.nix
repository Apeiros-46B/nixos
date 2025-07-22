{ pkgs, theme, ... }:

let
	setDefault = Value: {
		inherit Value;
		Status = "default";
	};
	setLocked = Value: {
		inherit Value;
		Status = "locked";
	};
	extsToAttrs = exts: builtins.listToAttrs (map
		(id: {
			name = id;
			value = {
				install_url = "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi";
				installation_mode = "normal_installed";
			};
		})
		exts);
	installExts = exts: { "*".installation_mode = "allowed"; } // extsToAttrs exts;
in {
	hm.home.packages = with pkgs; [
		zoom-us
	];

	hm.programs.brave.enable = true;

	# for taking exams
	hm.programs.chromium = {
		enable = true;
		package = pkgs.ungoogled-chromium;
	};

	# main browser
	hm.programs.firefox = {
		enable = true;
		package = pkgs.wrapFirefox (pkgs.firefox-unwrapped.override {
			pipewireSupport = true;
		}) {};

		nativeMessagingHosts = with pkgs; [
			# "bind --mode=browser <C-,> composite !s ydotool key 64:1 64:0; !s ydotool key 64:1 64:0; escapehatch"
			# this tridactyl bind makes escapehatch not close sidebars like sidebery
			# replace "ydotool key 64:1 64:0" with "xdotool key F6" if on X11
			tridactyl-native
			ff2mpv
		];

		# {{{ settings and extensions
		policies = {
			DisableTelemetry = true;
			DisableFirefoxStudies = true;
			EnableTrackingProtection = {
				Value = true;
				Locked = true;
				Cryptomining = true;
				Fingerprinting = true;
			};
			DisablePocket = true;
			DisableFirefoxAccounts = false;
			DisableAccounts = false;
			DisableFirefoxScreenshots = true;
			OverrideFirstRunPage = "";
			OverridePostUpdatePage = "";
			DontCheckDefaultBrowser = false;
			DisplayBookmarksToolbar = "never";
			DisplayMenuBar = "never";
			SearchBar = "unified";

			ExtensionSettings = installExts [
				"{446900e4-71c2-419f-a6a7-df9c091e268b}" # bitwarden
				"{74145f27-f039-47ce-a470-a662b129930a}" # clearurls
				"jid1-MnnxcxisBPnSXQ@jetpack"            # privacy badger
				"uBlock0@raymondhill.net"

				"{aecec67f-0d10-4fa7-b7c7-609a2db280cf}" # violentmonkey
				"{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}" # stylus
				"{3c078156-979c-498b-8990-85f7987dd929}" # sidebery
				"tridactyl.vim@cmcaine.co.uk"

				"{92e6fe1c-6e1d-44e1-8bc6-d309e59406af}"         # hover zoom+ (the open source one)
				"{762f9885-5a13-4abd-9c77-433dcd38b8fd}"         # return youtube dislikes
				"enhancerforyoutube@maximerf.addons.mozilla.org" # enhancer for youtube
				"sponsorBlocker@ajay.app"                        # sponsorblock
				"ff2mpv@yossarian.net"                           # ff2mpv
			];
			Preferences = {
				"extensions.pocket.enabled" = setDefault false;
				"extensions.screenshots.disabled" = setDefault true;
				"toolkit.legacyUserProfileCustomizations.stylesheets" = setLocked true;
				"browser.contentblocking.category" = setDefault "strict";
				"browser.topsites.contile.enabled" = setDefault false;
				"browser.formfill.enable" = setDefault true;
				"browser.search.suggest.enabled" = setDefault false;
				"browser.search.suggest.enabled.private" = setDefault false;
				"browser.urlbar.suggest.searches" = setDefault false;
				"browser.urlbar.showSearchSuggestionsFirst" = setDefault false;
				"browser.sessionstore.restore_tabs_lazily" = setDefault false;
				"browser.newtabpage.activity-stream.feeds.section.topstories" = setDefault false;
				"browser.newtabpage.activity-stream.feeds.snippets" = setDefault false;
				"browser.newtabpage.activity-stream.section.highlights.includePocket" = setDefault false;
				"browser.newtabpage.activity-stream.section.highlights.includeDownloads" = setDefault false;
				"browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = setDefault false;
				"browser.newtabpage.activity-stream.section.highlights.includeVisited" = setDefault false;
				"browser.newtabpage.activity-stream.showSponsored" = setDefault false;
				"browser.newtabpage.activity-stream.system.showSponsored" = setDefault false;
				"browser.newtabpage.activity-stream.showSponsoredTopSites" = setDefault false;
			};
		};
		# }}}

		profiles.apeiros = {
			containers = {
				Personal = {
					id = 0;
					icon = "circle";
					color = "blue";
				};
				School = {
					id = 1;
					icon = "circle";
					color = "green";
				};
			};
			# {{{ custom theme
			userChrome = with theme.colorsHash; ''
				@import '${pkgs.my.verticalfox}/linux/userChrome.css';

				:root {
					--bg: ${bg0};
					--urlbar-bg: ${bg1};
					--urlbar-border-top: ${bg0};
					--urlbar-border-bottom: ${bg0};
					--urlbar-outline: ${blue};
					--urlbar-height: 30px;
					--urldrop-bg: ${bg1};

					--fullscreen-warn: rgb(25, 25, 25);

					--arrowpanel-background: var(--urlbar-bg) !important;
					--button-hover-bgcolor: ${bg2} !important;
					--button-active-bgcolor: ${bgBlue} !important;
					--button-bgcolor: ${bg1} !important;
					--toolbarbutton-icon-fill-opacity: 1.0 !important;
					--arrowpanel-border-color: ${bg0} !important;
					--identity-btn-hover-color: ${bg2} !important;

					--dark-menu-background-color: ${bg1} !important;
					--dark-menu-border-color: ${bg1} !important;
					--dark-menuitem-hover-background-color: ${bg2} !important;
				}

				#urlbar,
				#urlbar-background {
					border-radius: 0px !important;
				}
				#urlbar {
					top: 6px !important;
				}
				#urlbar[breakout][breakout-extend] {
					top: 2px !important;
				}
				#urlbar[breakout][breakout-extend] > #urlbar-background {
					border-radius: 0 !important;
				}

				#identity-icon-box.identity-box-button {
					margin: 0 !important;
					opacity: 1 !important;
					border-radius: 0px !important;
					background-color: ${bg2} !important;
				}

				#nav-bar {
					padding-right: 0px !important;
				}
				toolbarbutton.titlebar-button {
					display: none !important;
				}
			'';
			# }}}
		};
	};
}
