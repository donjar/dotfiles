set tabstop=4 softtabstop=0 noexpandtab shiftwidth=4 cc=81 number showcmd
set undofile backup
set backupdir=~/.vimtmp,.
set directory=~/.vimtmp,.
set undodir=~/.vimtmp,.

" Escape terminal
tnoremap <esc> <C-\><C-n>

" Disable mouse
set mouse=h

" Tab settings
autocmd FileType eruby setlocal shiftwidth=2 tabstop=2 expandtab
"autocmd FileType javascript setlocal shiftwidth=2 tabstop=2 expandtab
autocmd FileType html setlocal shiftwidth=2 tabstop=2 expandtab
autocmd FileType scss setlocal shiftwidth=2 tabstop=2 expandtab
autocmd FileType yaml setlocal shiftwidth=2 tabstop=2 expandtab
autocmd FileType ruby setlocal shiftwidth=2 tabstop=2 expandtab

" Add listchars
set listchars=tab:>·,space:␣

let maplocalleader='\'

call plug#begin()
" Sensible defaults
Plug 'tpope/vim-sensible'
" Nerdtree - file browser in sidebar.
Plug 'scrooloose/nerdtree'
" Syntastic - syntax checker.
Plug 'scrooloose/syntastic'
" YouCompleteMe - autocomplete.
"Plug 'Valloric/YouCompleteMe'
" Pretty status line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" base16 color scheme
Plug 'chriskempson/base16-vim'
" Git things
Plug 'tpope/vim-fugitive'
" Show git diff in gutter
Plug 'airblade/vim-gitgutter'
" Auto close parantheses
Plug 'jiangmiao/auto-pairs'

" LaTeX
Plug 'lervag/vimtex'
" Scala
Plug 'derekwyatt/vim-scala'
" Rails stuff
Plug 'tpope/vim-rails'
Plug 'tpope/vim-bundler'
call plug#end()

" Enter NERDTree on start
autocmd VimEnter * :NERDTree
" Ignore pyc files
let NERDTreeIgnore = ['\.pyc$']

" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_loc_list_height = 3
let g:syntastic_mode_map = {
	\ "mode": "passive",
	\ "active_filetypes": [],
	\ "passive_filetypes": [] }

nnoremap <C-c> :SyntasticCheck<CR>
nnoremap <C-A-c> :SyntasticReset<CR>
nnoremap <C-n> :noh<CR>

" Base16 color scheme
let base16colorspace=256
colorscheme base16-dracula

let g:syntastic_python_checkers = ['flake8']
let g:syntastic_ruby_checkers = ['rubocop']
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_haml_checkers = ['haml_lint']
let g:syntastic_scss_checkers = ['scss_lint']

let g:vimtex_latexmk_options = '-pdf -shell-escape -verbose -file-line-error -synctex=1 -interaction=nonstopmode'
