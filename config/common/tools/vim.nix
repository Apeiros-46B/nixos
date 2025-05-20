{ pkgs, theme, ... }:

let
	buildPlugin = pkgs.vimUtils.buildVimPlugin;
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

				" {{{ colorscheme
				" highlights adapted from everforest
				set termguicolors
				set background=dark

				" from nano-emacs
				hi FaceNormal ctermfg=15 guifg=${fg1} ctermbg=NONE guibg=NONE
				hi FaceCritical ctermfg=1 guifg=${red} ctermbg=NONE guibg=NONE cterm=bold,underline term=bold,underline
				hi FacePopout ctermfg=5 guifg=${purple} ctermbg=NONE guibg=NONE cterm=bold term=bold
				hi FaceStrong ctermfg=15 guifg=${fg1} ctermbg=NONE guibg=NONE cterm=bold term=bold
				hi FaceSalient ctermfg=4 guifg=${blue} ctermbg=NONE guibg=NONE
				hi FaceFaded ctermfg=7 guifg=${fg2} ctermbg=NONE guibg=NONE
				hi FaceSubtle ctermfg=7 guifg=${fg2} ctermbg=8 guibg=${bg2}
				hi FaceSubtleAlt ctermfg=7 guifg=${fg2} ctermbg=8 guibg=${bg3}

				" from elysium
				hi Red ctermfg=1 guifg=${red} ctermbg=NONE guibg=NONE
				hi Orange ctermfg=1 guifg=${orange} ctermbg=NONE guibg=NONE
				hi Yellow ctermfg=3 guifg=${yellow} ctermbg=NONE guibg=NONE
				hi Green ctermfg=2 guifg=${green} ctermbg=NONE guibg=NONE
				hi Aqua ctermfg=6 guifg=${cyan} ctermbg=NONE guibg=NONE
				hi Blue ctermfg=4 guifg=${blue} ctermbg=NONE guibg=NONE
				hi Purple ctermfg=5 guifg=${purple} ctermbg=NONE guibg=NONE
				hi Normal ctermfg=15 guifg=${fg1} ctermbg=0 guibg=${bg1}
				hi EndOfBuffer ctermfg=0 guifg=${bg1} ctermbg=NONE guibg=NONE
				hi Folded ctermfg=7 guifg=${fg2} ctermbg=8 guibg=${bg2}
				hi FoldColumn ctermfg=7 guifg=${bg6} ctermbg=NONE guibg=NONE
				hi SignColumn ctermfg=15 guifg=${fg1} ctermbg=NONE guibg=NONE
				hi ToolbarLine ctermfg=15 guifg=${fg1} ctermbg=8 guibg=${bg3}
				hi IncSearch ctermfg=2 guifg=${green} ctermbg=0 guibg=${bg1} cterm=reverse term=reverse
				hi Search ctermfg=2 guifg=${green} ctermbg=NONE guibg=NONE
				hi Conceal ctermfg=7 guifg=${fg2} ctermbg=NONE guibg=NONE
				hi Cursor ctermfg=NONE guifg=NONE ctermbg=NONE guibg=NONE cterm=reverse term=reverse
				hi CursorLine ctermfg=NONE guifg=NONE ctermbg=8 guibg=${bg2} cterm=NONE term=NONE
				hi CursorColumn ctermfg=NONE guifg=NONE ctermbg=8 guibg=${bg2}
				hi LineNr ctermfg=7 guifg=${bg6} ctermbg=NONE guibg=NONE
				hi CursorLineNr ctermfg=75 guifg=${fg3} ctermbg=NONE guibg=${bg2} cterm=NONE term=NONE
				hi DiffAdd ctermfg=2 guifg=NONE ctermbg=NONE guibg=${bgGreen}
				hi DiffChange ctermfg=4 guifg=NONE ctermbg=NONE guibg=${bgBlue}
				hi DiffDelete ctermfg=1 guifg=NONE ctermbg=NONE guibg=${bgRed}
				hi DiffText ctermfg=4 guifg=${blue} ctermbg=0 guibg=${bg1} cterm=reverse term=reverse
				hi Directory ctermfg=15 guifg=${fg1} ctermbg=NONE guibg=NONE
				hi ErrorMsg ctermfg=1 guifg=${red} ctermbg=NONE guibg=NONE cterm=bold,underline term=bold,underline
				hi WarningMsg ctermfg=6 guifg=${yellow} ctermbg=NONE guibg=NONE cterm=bold term=bold
				hi ModeMsg ctermfg=15 guifg=${fg1} ctermbg=NONE guibg=NONE cterm=bold term=bold
				hi MoreMsg ctermfg=6 guifg=${yellow} ctermbg=NONE guibg=NONE cterm=bold term=bold
				hi MatchParen ctermfg=NONE guifg=NONE ctermbg=8 guibg=${bg5}
				hi NonText ctermfg=7 guifg=${bg6} ctermbg=NONE guibg=NONE
				hi SpecialKey ctermfg=7 guifg=${bg6} ctermbg=NONE guibg=NONE
				hi Pmenu ctermfg=15 guifg=${fg1} ctermbg=8 guibg=${bg3}
				hi PmenuSbar ctermfg=NONE guifg=NONE ctermbg=8 guibg=${bg3}
				hi PmenuSel ctermfg=0 guifg=${bg1} ctermbg=2 guibg=${green}
				hi PmenuKind ctermfg=2 guifg=${green} ctermbg=8 guibg=${bg3}
				hi PmenuExtra ctermfg=15 guifg=${fg4} ctermbg=8 guibg=${bg3}
				hi PmenuThumb ctermfg=NONE guifg=NONE ctermbg=7 guibg=${fg3}
				hi NormalFloat ctermfg=15 guifg=${fg1} ctermbg=8 guibg=${bg3}
				hi FloatBorder ctermfg=7 guifg=${fg2} ctermbg=8 guibg=${bg3}
				hi FloatTitle ctermfg=15 guifg=${fg1} ctermbg=8 guibg=${bg3} cterm=bold term=bold
				hi Question ctermfg=6 guifg=${yellow} ctermbg=NONE guibg=NONE
				hi StatusLine ctermfg=7 guifg=${fg2} ctermbg=8 guibg=${bg3} cterm=NONE term=NONE
				hi StatusLineTerm ctermfg=7 guifg=${fg2} ctermbg=8 guibg=${bg3} cterm=NONE term=NONE
				hi StatusLineNC ctermfg=7 guifg=${fg2} ctermbg=8 guibg=${bg2} cterm=NONE term=NONE
				hi StatusLineTermNC ctermfg=7 guifg=${fg2} ctermbg=0 guibg=${bg2} cterm=NONE term=NONE
				hi TabLine ctermfg=15 guifg=${fg4} ctermbg=8 guibg=${bg4}
				hi TabLineFill ctermfg=7 guifg=${fg2} ctermbg=8 guibg=${bg2}
				hi TabLineSel ctermfg=0 guifg=${bg1} ctermbg=2 guibg=${green}
				hi VertSplit ctermfg=8 guifg=${bg5} ctermbg=NONE guibg=NONE cterm=NONE term=NONE
				hi Visual ctermfg=NONE guifg=NONE ctermbg=8 guibg=${bgVisual}
				hi VisualNOS ctermfg=NONE guifg=NONE ctermbg=8 guibg=${bgVisual}
				hi QuickFixLine ctermfg=5 guifg=${purple} ctermbg=NONE guibg=NONE cterm=bold term=bold
				hi Debug ctermfg=1 guifg=${orange} ctermbg=NONE guibg=NONE
				hi ToolbarButton ctermfg=0 guifg=${bg1} ctermbg=2 guibg=${green}
				hi qfFileName ctermfg=7 guifg=${fg2} ctermbg=NONE guibg=NONE
				hi qfLineNr ctermfg=15 guifg=${fg1} ctermbg=NONE guibg=NONE

				hi! link CurSearch IncSearch
				hi! link vCursor Cursor
				hi! link iCursor Cursor
				hi! link lCursor Cursor
				hi! link CursorIM Cursor
				hi! link WildMenu PmenuSel
				hi! link WinSeparator VertSplit

				let g:terminal_ansi_colors = [
					\ '${bg1}', '${red}', '${green}', '${yellow}', '${blue}', '${purple}', '${cyan}', '${fg2}',
					\ '${bg2}', '${red}', '${green}', '${yellow}', '${blue}', '${purple}', '${cyan}', '${fg1}',
					\ ]
				" }}}

				" {{{ syntax highlight
				func SimpleSyntax()
					syntax on
					syntax reset

					" stripped down version of elysium
					hi! link Boolean Purple
					hi! link Number Purple
					hi! link Float Purple
					hi! link PreProc Purple
					hi! link PreCondit Purple
					hi! link Include Red
					hi! link Define Purple
					hi! link Conditional Blue
					hi! link Repeat Blue
					hi! link Keyword Blue
					hi! link Typedef Blue
					hi! link Exception Red
					hi! link Statement Blue
					hi! link Error FaceCritical
					hi! link StorageClass Blue
					hi! link Tag FaceNormal
					hi! link Label Orange
					hi! link Structure Blue
					hi! link Operator Orange
					hi! link Title FaceNormal
					hi! link Special Aqua
					hi! link SpecialChar Green
					hi! link Type Yellow
					hi! link Function Green
					hi! link String Aqua
					hi! link Character Aqua
					hi! link Constant Purple
					hi! link Macro Purple
					hi! link Identifier FaceNormal
					hi! link Todo Blue
					hi! link Comment FaceFaded
					hi! link SpecialComment FaceFaded
					hi! link Delimiter FaceNormal
					hi! link Ignore FaceFaded
					hi! link Underlined FaceNormal
				endfunc
				" }}}

				" autocmds
				au FileType qf call QfSetup()
				au FileType rust compiler cargo
				au BufEnter * call SimpleSyntax()
				au InsertEnter * set nornu
				au InsertLeave * set rnu
				au TerminalOpen * setlocal nonu nornu nocursorline nobuflisted
			'';
		})
	];
}
