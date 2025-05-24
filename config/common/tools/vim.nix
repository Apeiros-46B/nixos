{ pkgs, globals, theme, ... }:

let
	buildPlugin = pkgs.vimUtils.buildVimPlugin;
	useTruecolor = theme.name == "elysium" && globals.hostType != "server";
in {
	environment.variables = {
		EDITOR = "vim";
		VISUAL = "vim";
	};
	environment.systemPackages = [
		(pkgs.vim-full.customize {
			vimrcConfig.packages.plugins.start = with pkgs.vimPlugins; [
				(buildPlugin {
					name = "vim-surround";
					src = pkgs.fetchFromGitHub {
						owner = "tpope";
						repo = "vim-surround";
						rev = "3d188ed2113431cf8dac77be61b842acb64433d9";
						sha256 = "DZE5tkmnT+lAvx/RQHaDEgEJXRKsy56KJY919xiH1lE=";
					};
				})
				(buildPlugin {
					name = "auto-pairs";
					src = pkgs.fetchFromGitHub {
						owner = "jiangmiao";
						repo = "auto-pairs";
						rev = "39f06b873a8449af8ff6a3eee716d3da14d63a76";
						sha256 = "zyLwbGp0y5XuLCbA7A3NL9EHh5jf9K7X7XerykoJrsM=";
					};
				})
				(buildPlugin {
					name = "elysium.vim";
					src = pkgs.fetchFromGitHub {
						owner = "Apeiros-46B";
						repo = "elysium";
						rev = "8a378de33c8358d6002eb6c87cd49b6eb61daef8";
						sha256 = "Iz6HhxQKbhdZXeQuIm9HE2VoJ7+hDPk5xJGD0ilWCs4=";
					};
					sourceRoot = "source/ports/vim";
				})
				vim-oscyank
				vim-automkdir
			];
			vimrcConfig.customRC = with theme.colorsHash; ''
				" files
				set autoread
				set modeline modelines=5
				filetype plugin indent on

				" editing
				let g:nix_recommended_style = 0
				let g:rust_recommended_style = 0
				set backspace=indent,eol,start
				set tabstop=2 softtabstop=-1 shiftwidth=0 noexpandtab smartindent
				set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
				command -nargs=+ Grep exe 'silent! grep <args>' | redraw! | copen
				command -nargs=* Make exe 'silent! make <args>' | redraw! | copen

				" UI
				" {{{ statusline
				let g:modes = {
					\ 'n':     'N',
					\ 'no':    'O',
					\ 'nov':   'O',
					\ 'noV':   'O',
					\ 'no':  'O',
					\ 'niI':   'i',
					\ 'niR':   'r',
					\ 'niV':   'r',
					\ 'nt':    'N',
					\ 'v':     'V',
					\ 'vs':    'V',
					\ 'V':     'V',
					\ 'Vs':    'V',
					\ '':    'V',
					\ 's':   'V',
					\ 's':     'S',
					\ 'S':     'S',
					\ '\19':   'S',
					\ 'i':     'I',
					\ 'ic':    'I',
					\ 'ix':    'I',
					\ 'R':     'R',
					\ 'Rc':    'R',
					\ 'Rx':    'R',
					\ 'Rv':    'R',
					\ 'Rvc':   'R',
					\ 'Rvx':   'R',
					\ 'c':     'C',
					\ 'cv':    'C',
					\ 'r':     'C',
					\ 'rm':    'C',
					\ 'r?':    'C',
					\ '!':     'T',
					\ 't':     'T',
					\ }
				func! StlRspace()
					return winnr() == winnr('l') ? ' ' : '''
				endfunc

				set statusline=\ %{g:modes[mode()]}\ " space
				set statusline+=%F\ %m%R
				set statusline+=%=
				set statusline+=%l:%c%V%{StlRspace()}
				" }}}

				" {{{ quickfix
				func QfTitle()
					return get(w:, 'quickfix_title', "")
				endfunc

				func QfSetup()
					syntax clear
					setlocal nowrap foldmethod=manual
					setlocal statusline=\ Q\ %{QfTitle()}%=%l/%L%{StlRspace()}
				endfunc

				func QfFormat(info)
					let items = a:info.quickfix ? getqflist() : getloclist(a:info.winid)
					let iter = range(a:info.start_idx - 1, a:info.end_idx - 1)

					let col1 = []
					let col2 = []
					let col3 = []
					let res = []

					let max_f_len = 0
					let max_ln_len = 0
					let max_col_len = 0

					for i in iter
						let cargo_subst = ':s?^\~/\.cargo/registry/src/[^/]*/\([^/]*\)/.\{-}\([^/]\+.rs\)?crate:\1/\2?'
						let f = fnamemodify(bufname(items[i].bufnr), ':p:~:.' . cargo_subst)
						let ln = items[i].lnum == 0 ? ' ' : items[i].lnum

						call add(col1, f)
						call add(col2, ln)
						call add(col3, items[i].text)

						let l = strwidth(f)
						if l > max_f_len
							let max_f_len = l
						endif

						let l = len(ln)
						if l > max_ln_len
							let max_ln_len = l
						endif
					endfor

					for i in iter
						let f = col1[i]
						let ln = col2[i]
						let f_padding = repeat(' ', max_f_len - strwidth(f))
						let ln_padding = repeat(' ', max_ln_len - len(ln))
						call add(res, f . f_padding . ' ' . ln_padding . ln . ' ' . col3[i])
					endfor

					return res
				endfunc

				set quickfixtextfunc=QfFormat
				" }}}

				set nu rnu
				set cursorline cursorlineopt=both
				set list listchars=tab:\.\ " space
				set scrolloff=2
				set hlsearch incsearch ignorecase smartcase
				set laststatus=2
				set wildmenu cmdheight=1
				set noshowmode shortmess=aoOstTcFS showcmd showcmdloc=last
				set foldmethod=marker
				set fillchars+=fold:\ ,eob:\ ,vert:\ " space
				set splitbelow splitright

				" keybinds
				let g:mapleader = ' '
				nmap <leader>x <Cmd>bd<CR>
				nmap <leader>X <Cmd>bd!<CR>
				nmap <leader>j <Cmd>bp!<CR>
				nmap <leader>k <Cmd>bn!<CR>
				nmap <leader>qf <Cmd>cw<CR>
				nmap <leader>qj <Cmd>cnext<CR>
				nmap <leader>qk <Cmd>cprev<CR>
				nmap <leader>Qj <Cmd>lnext<CR>
				nmap <leader>Qk <Cmd>lprev<CR>
				nmap <leader>qJ <Cmd>cbelow<CR>
				nmap <leader>qK <Cmd>cabove<CR>
				nmap <leader>QJ <Cmd>lbelow<CR>
				nmap <leader>QK <Cmd>labove<CR>
				nmap <leader><CR> <Cmd>vertical botright terminal<CR>
				nmap <leader><Bslash> <Cmd>terminal<CR>
				vmap <leader>y <Plug>OSCYankVisual
				nmap <leader>y <Plug>OSCYankOperator
				nmap <leader>yy <leader>y_
				nmap cc <Cmd>silent! nohl<CR>
				tmap <C-w><C-n> <C-\><C-n>

				set background=dark
				set ${if useTruecolor then "termguicolors" else "notermguicolors"}
				let g:elysium_256color = v:false
				colorscheme elysium

				" autocmds
				au FileType qf call QfSetup()
				au FileType rust compiler cargo
				au InsertEnter * set nornu
				au InsertLeave * set rnu
				au TerminalOpen * setlocal nonu nornu nocursorline nobuflisted
			'';
		})
	];
}
