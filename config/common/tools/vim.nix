{ lib, pkgs, functions, ... }:

let
	buildPlugin = pkgs.vimUtils.buildVimPlugin;
in {
	environment.variables.EDITOR = "vim";
	environment.systemPackages = [
		(pkgs.vim-full.customize {
			vimrcConfig.packages.plugins.start = with pkgs.vimPlugins; [
				(buildPlugin {
					name = "everforest";
					src = pkgs.fetchFromGitHub {
						owner = "sainnhe";
						repo = "everforest";
						rev = "d855af543410c4047fc03798f5d58ddd07abcf2d";
						sha256 = "3YXKNpvhjq7grGBiW+RcbSmupGPariGkX0I7Vu9DXmo=";
					};
				})
				(buildPlugin {
					name = "vim-surround";
					src = pkgs.fetchFromGitHub {
						owner = "tpope";
						repo = "vim-surround";
						rev = "3d188ed2113431cf8dac77be61b842acb64433d9";
						sha256 = "DZE5tkmnT+lAvx/RQHaDEgEJXRKsy56KJY919xiH1lE=";
					};
				})
				vim-oscyank
				vim-nix
				fugitive
			];
			vimrcConfig.customRC = ''
				" colorscheme
				set termguicolors
				set background=dark
				let g:everforest_background = 'hard'
				silent! colorscheme everforest
				let g:terminal_ansi_colors[0] = '#3a454a'
				let g:terminal_ansi_colors[8] = '#859289'

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
				nmap WW :w<CR>
				tmap <C-w><C-n> <C-\><C-n>

				" autocmds
				au InsertEnter * set nornu
				au InsertLeave * set rnu
				au TerminalOpen * setlocal nonu nornu nocursorline
			'';
		})
	];
}
