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
Plug 'w0rp/ale'
" File browser in sidebar
Plug 'scrooloose/nerdtree'
" Quoting/parenthesizing made simple
Plug 'tpope/vim-surround'
" Dark powered asynchronous completion framework (?)
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
" Auto add `end` on Ruby etc.
Plug 'tpope/vim-endwise'

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
" Java
Plug 'artur-shaik/vim-javacomplete2'
" Rust
Plug 'rust-lang/rust.vim'
" Swift
Plug 'keith/swift.vim'
" Fish
Plug 'dag/vim-fish'
call plug#end()

"" ALE
" Integrate with Airline
let g:airline#extensions#ale#enabled = 1
" Set 1000 ms delay before checking
let g:ale_completion_delay = 1000

"" NEOVIM
" Escape terminal
tnoremap <esc> <C-\><C-n>

"" NERDTREE - file browser in sidebar
" Enter NERDTree on start
autocmd VimEnter * :NERDTree
" Ignore pyc files
let NERDTreeIgnore = ['\.pyc$']

"" BASE16 - vim/terminal color scheme
let base16colorspace = 256
colorscheme base16-dracula

"" DEOPLETE
" Enable it
let g:deoplete#enable_at_startup = 1
" Let <Tab> also do completion
inoremap <expr><Tab>  pumvisible() ? "\<C-n>" : "<Tab>"
" Map Shift + Tab to prev
inoremap <S-Tab> <C-p>
" Auto close after enter
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function() abort
 return deoplete#close_popup() . "\<CR>"
endfunction

"" ALE
" Do not lint on text change
let g:ale_lint_on_text_changed = 'never'
" Only those linters that I want
let g:ale_linters_explicit = 1
let g:ale_linters = {'ruby': ['rubocop']}

"" LANGUAGE-SPECIFIC

" LaTeX: default latexmk options for vimtex
let g:vimtex_latexmk_options = '-pdf -shell-escape -verbose -file-line-error -synctex=1 -interaction=nonstopmode'
" Deoplete for LaTeX
if !exists('g:deoplete#omni#input_patterns')
    let g:deoplete#omni#input_patterns = {}
endif
let g:deoplete#omni#input_patterns.tex = g:vimtex#re#deoplete

" Python: don't use PEP8 recommendation of 4 spaces
let g:python_recommended_style = 0

let g:ale_linters = {'python': []}

" Swift: use 4 spaces
autocmd FileType swift setlocal shiftwidth=4 tabstop=4

" Typescript: linebreak at 100 chars and use ES2015
autocmd FileType typescript setlocal cc=101
let g:typescript_compiler_options = '--target ES6'

" Java: got this from StackOverflow, set make to javac. Also use 4 spaces
autocmd Filetype java set makeprg=javac\ %:S shiftwidth=4 tabstop=4
set errorformat=%A%f:%l:\ %m,%-Z%p^,%-C%.%#

" C: use 4 spaces
autocmd FileType c setlocal shiftwidth=4 tabstop=4

" Rust: don't use recommendation of 4 spcaes
let g:rust_recommended_style = 0
