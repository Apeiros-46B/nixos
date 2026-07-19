{ inputs, config, globals, ... }:

{
	imports = [ inputs.shimmie2.nixosModules.default ];

	sops.secrets.shimmie-env = {
		sopsFile = ./Secrets.yaml;
		owner = "shimmie";
		group = "shimmie";
		mode = "0400";
	};

	services.shimmie = {
		enable = true;
		stateDir = "/var/lib/shimmie2";
		dataDir = "/mnt/nas/shimmie2";
		dbPath = "/mnt/nas/shimmie2/shimmie.db";
		envFile = config.sops.secrets.shimmie-env.path;
		port = 9000;

		extensions = [
			"approval" "auto_tagger" "autocomplete" "blocks" "bulk_add" "bulk_add_csv"
			"custom_html_headers" "favorites" "handle_video" "home" "image_view_counter"
			"link_image" "log_console" "notes" "pools" "post_titles" "private_image"
			"random_list" "source_history" "tag_categories" "tag_history" "tag_tools"
			"trash"
		];

		seedSql = [
			{
				oneshot = true;
				requires = [ "config" ];
				sql = ''
					INSERT INTO config (name, value)
					VALUES
						('login_signup_enabled', 'N'),
						('nice_urls', 'Y'),
						('transload_engine', 'curl'),
						('index_images', 50),
						('upload_count', 10),
						('upload_size', 26214400),
						('title', 'img.apeiros.xyz'),
						('sitename_in_title', 'prefix'),
						('home_counter', 'none'),
						('front_page', 'home'),
						('main_page', 'post/list'),
						('theme', 'lite'),
						('custom_html_headers', '<style>@import url("https://fonts.googleapis.com/css2?family=IBM+Plex+Sans:ital,wght@0,100..700;1,100..700&display=swap"); :not(textarea){font-family:"IBM Plex Sans",sans-serif;} body header div.menu a {display: none;}</style>')
					ON CONFLICT(name) DO UPDATE SET value = EXCLUDED.value;
				'';
			}
			{
				oneshot = true;
				requires = [ "image_tag_categories" ];
				sql = ''
					INSERT INTO image_tag_categories (category, display_singular, display_multiple, color)
					VALUES
						('artist', 'Artist', 'Artists', '#904961'),
						('series', 'Series', 'Series', '#535D9C'),
						('character', 'Character', 'Characters', '#546B4F'),
						('type', 'Type', 'Types', '#406B75'),
						('meta', 'Meta', 'Meta', '#79508A')
					ON CONFLICT(category) DO UPDATE SET
						display_singular = EXCLUDED.display_singular,
						display_multiple = EXCLUDED.display_multiple,
						color = EXCLUDED.color;
				'';
			}
			{
				oneshot = true;
				requires = [ "blocks" ];
				sql = ''
					INSERT INTO blocks (id, pages, title, area, priority, content, userclass)
					VALUES
						(1, '*', 'Admin', 'left', 1000, '<a href="/user_config">User Options</a><br><a href="/alias/list">Alias Editor</a><br><a href="/auto_tag/list">Auto-Tag Editor</a><br><a href="/ext_manager">Extension Manager</a><br><a href="/admin">Board Admin</a><br><a href="/setup">Board Config</a><br><a href="/blocks/list">Blocks Editor</a><br><a href="/user_admin/list">User List</a><br><a href="/perm_manager">Permission Manager</a><br><a href="/system_info">System Info</a><br><a href="/source_history/all/1">Source Changes</a><br><a href="/tag_history/all/1">Tag Changes</a><br><a href="/post/list/in%3Atrash/1">Trash</a><br><a href="/user_admin/logout">Log Out</a>', 'Admin')
					ON CONFLICT(id) DO UPDATE SET
						pages = EXCLUDED.pages,
						title = EXCLUDED.title,
						area = EXCLUDED.area,
						priority = EXCLUDED.priority,
						content = EXCLUDED.content,
						userclass = EXCLUDED.userclass;
				'';
			}
		];

		settings = {
			cacheDsn = "apc://";
			timezone = "UTC";
		};

		nginx = {
			enable = true;
			virtualHost = "img.${globals.net.tsDomain}";
			forceSSL = true;
			useACMEHost = globals.net.tsDomain;
		};
	};
}
