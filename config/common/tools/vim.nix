{ lib, pkgs, theme, ... }:

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
			];
			vimrcConfig.customRC = with theme.colorsHash; ''
				" files
				set autoread
				set modeline modelines=5
				filetype plugin indent on

				" editing
				set tabstop=2 softtabstop=-1 shiftwidth=0 noexpandtab smartindent
				set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
				let g:nix_recommended_style = 0

				" UI
				set nu rnu
				set cursorline cursorlineopt=both
				set list listchars=tab:\.\ " space at end!
				set foldmethod=marker
				set scrolloff=2
				set hlsearch incsearch ignorecase smartcase
				set shortmess=aoOstTcFS
				set wildmenu
				set cmdheight=1
				set laststatus=2
				set fillchars+=vert:\ " space at end!
				set splitbelow splitright

				" keybinds
				let g:mapleader = ' '
				nmap <leader>x <Cmd>bd<CR>
				nmap <leader>X <Cmd>bd!<CR>
				nmap <leader>j <Cmd>bp!<CR>
				nmap <leader>k <Cmd>bn!<CR>
				nmap <leader><CR> <Cmd>vertical botright terminal<CR>
				nmap <leader><Bslash> <Cmd>terminal<CR>
				nmap <leader>y <Plug>OSCYankOperator
				nmap <leader>yy <leader>y_
				vmap <leader>y <Plug>OSCYankVisual
				nmap cc :nohl<CR>
				tmap <C-w><C-n> <C-\><C-n>

				" autocmds
				au InsertEnter * set nornu
				au InsertLeave * set rnu
				au TerminalOpen * setlocal nonu nornu nocursorline

				" colorscheme
				" highlights adapted from everforest
				set termguicolors
				set background=dark

				hi Normal ctermfg=15 guifg=${fg1} ctermbg=0 guibg=${bg1}
				hi EndOfBuffer ctermfg=0 guifg=${bg1} ctermbg=NONE guibg=NONE
				hi Folded ctermfg=7 guifg=${fg2} ctermbg=0 guibg=${bg2}
				hi FoldColumn ctermfg=7 guifg=${bg6} ctermbg=NONE guibg=NONE
				hi SignColumn ctermfg=15 guifg=${fg1} ctermbg=NONE guibg=NONE
				hi ToolbarLine ctermfg=15 guifg=${fg1} ctermbg=0 guibg=${bg3}
				hi IncSearch ctermfg=2 guifg=${green} ctermbg=0 guibg=${bg1} cterm=reverse term=reverse
				hi Search ctermfg=2 guifg=${green} ctermbg=0 guibg=${bg1}
				hi Conceal ctermfg=7 guifg=${bg6} ctermbg=NONE guibg=NONE
				hi Cursor ctermfg=NONE guifg=NONE ctermbg=NONE guibg=NONE cterm=reverse term=reverse
				hi CursorLine ctermfg=NONE guifg=NONE ctermbg=8 guibg=${bg2} cterm=NONE term=NONE
				hi CursorColumn ctermfg=NONE guifg=NONE ctermbg=8 guibg=${bg2}
				hi LineNr ctermfg=7 guifg=${bg6} ctermbg=NONE guibg=NONE
				hi CursorLineNr ctermfg=75 guifg=${fg3} ctermbg=NONE guibg=${bg2} cterm=NONE term=NONE
				hi DiffAdd ctermfg=2 guifg=NONE ctermbg=NONE guibg=${bgGreen}
				hi DiffChange ctermfg=4 guifg=NONE ctermbg=NONE guibg=${bgBlue}
				hi DiffDelete ctermfg=1 guifg=NONE ctermbg=NONE guibg=${bgRed}
				hi DiffText ctermfg=4 guifg=${blue} ctermbg=0 guibg=${bg1} cterm=reverse term=reverse
				hi Directory ctermfg=2 guifg=${green} ctermbg=NONE guibg=NONE
				hi ErrorMsg ctermfg=1 guifg=${red} ctermbg=NONE guibg=NONE cterm=bold,underline term=bold,underline
				hi WarningMsg ctermfg=6 guifg=${yellow} ctermbg=NONE guibg=NONE cterm=bold term=bold
				hi ModeMsg ctermfg=15 guifg=${fg1} ctermbg=NONE guibg=NONE cterm=bold term=bold
				hi MoreMsg ctermfg=6 guifg=${yellow} ctermbg=NONE guibg=NONE cterm=bold term=bold
				hi MatchParen ctermfg=NONE guifg=NONE ctermbg=8 guibg=${bg5}
				hi NonText ctermfg=8 guifg=${bg5} ctermbg=NONE guibg=NONE
				hi SpecialKey ctermfg=8 guifg=${bg4} ctermbg=NONE guibg=NONE
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

				hi! link CurSearch IncSearch
				hi! link vCursor Cursor
				hi! link iCursor Cursor
				hi! link lCursor Cursor
				hi! link CursorIM Cursor
				hi! link WildMenu PmenuSel
				hi! link WinSeparator VertSplit

				let g:terminal_ansi_colors = [
					\ '${bg1}', '${red}', '${green}', '${yellow}', '${blue}', '${purple}', '${cyan}', '${fg2}',
					\ '${bg3}', '${red}', '${green}', '${yellow}', '${blue}', '${purple}', '${cyan}', '${fg1}',
					\ ]
			'';
		})
	];
}
