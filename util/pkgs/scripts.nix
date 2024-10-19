# TODO
{ pkgs }:

[
	(pkgs.writeShellScriptBin "autominimize" ''
		# concatenate all args into a string
		concat() {
			for i in "$@"; do
				printf %s\\n "$i" | sed "s/'/'\\\\''\''/g;1s/^/'/;\$s/\$/' \\\\/"
			done
			echo ' '
		}

		usage() {
			>&2 echo "expected $1"
			exit 1
		}

		[ "$1" ] || usage "unminimize: true/false"
		[ "$2" ] || usage "command [args...]"

		unminimize="$1"
		program="$2"
		shift 2

		${pkgs.awesome-git}/bin/awesome-client '
			local c = client.focus
			c.minimized = true
			require("awful").spawn.easy_async_with_shell(
				[[cd "'"$PWD"'"; '"$program"' '"$(concat "$@")"']],
				function() '"$(
					[ "$unminimize" = 'true' ] && echo 'pcall(function() c.minimized = false end)'
				)"' end
			)
		'
	'')
]
