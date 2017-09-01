"" GENERAL
" Use 2 spaces and some magic
set tabstop=2
set softtabstop=0
set shiftwidth=2
" Expand tabs into spaces
set expandtab
" Highlight searches
set hlsearch
" Add line marker at 81th character
set cc=81
" Show line numbers
set number
" Show partial commands at bottom right
set showcmd

" Set undo files and backup files in ~/.vimtmp
set undofile backup
set backupdir=~/.vimtmp,.
set directory=~/.vimtmp,.
set undodir=~/.vimtmp,.

" Disable mouse
set mouse=h

" On `:set list` show space with ␣ and tab with >·
set listchars=tab:>·,space:␣

" Use \ as local leader, for LaTeX etc.
let maplocalleader='\'

" Map Ctrl+N to :noh
nnoremap <C-n> :noh<CR>

"" PLUGINS
call plug#begin()
" Use sensible defaults
Plug 'tpope/vim-sensible'
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
" Syntax checkers
Plug 'scrooloose/syntastic'
" File browser in sidebar
Plug 'scrooloose/nerdtree'

" LaTeX
Plug 'lervag/vimtex'
" Scala
Plug 'derekwyatt/vim-scala'
" Rails stuff
Plug 'tpope/vim-rails'
Plug 'tpope/vim-bundler'
" Javascript stuff
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
" Typescript
Plug 'leafgarland/typescript-vim'
call plug#end()

"" NEOVIM
" Escape terminal
tnoremap <esc> <C-\><C-n>

"" SYNTASTIC - Syntax Checker
" These defaults are from Syntastic
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

" Map Ctrl+C to check syntax and Ctrl+Alt+C to remove syntax checker
nnoremap <C-c> :SyntasticCheck<CR>
nnoremap <C-A-c> :SyntasticReset<CR>

" Syntastic Checkers
let g:syntastic_python_checkers = ['flake8']
let g:syntastic_ruby_checkers = ['rubocop']
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_haml_checkers = ['haml_lint']
let g:syntastic_scss_checkers = ['scss_lint']
let g:syntastic_swift_checkers = ['swiftpm', 'swiftlint']

"" NERDTREE - file browser in sidebar
" Enter NERDTree on start
autocmd VimEnter * :NERDTree
" Ignore pyc files
let NERDTreeIgnore = ['\.pyc$']

"" BASE16 - vim/terminal color scheme
let base16colorspace = 256
colorscheme base16-dracula

"" LANGUAGE-SPECIFIC

" Javascript: Allow JSX in normal JS files
let g:syntastic_swift_checkers = ['swiftpm', 'swiftlint']

" LaTeX: default latexmk options for vimtex
let g:vimtex_latexmk_options = '-pdf -shell-escape -verbose -file-line-error -synctex=1 -interaction=nonstopmode'

" Python: don't use PEP8 recommendation of 4 spaces
let g:python_recommended_style = 0

" Swift: use 4 spaces
autocmd FileType swift setlocal shiftwidth=4 tabstop=4

" Typescript: linebreak at 100 chars and use ES2015
autocmd FileType typescript setlocal cc=101
let g:typescript_compiler_options = '--target ES6'

" Java: got this from StackOverflow, set make to javac
autocmd Filetype java set makeprg=javac\ %:S
set errorformat=%A%f:%l:\ %m,%-Z%p^,%-C%.%#
