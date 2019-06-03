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
" Nani?
set hidden

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
" Language server
Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }
" Fuzzy finder
Plug 'junegunn/fzf'
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
" Colorful parans
Plug 'kien/rainbow_parentheses.vim'

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
Plug 'peitalin/vim-jsx-typescript'
" Rust
Plug 'rust-lang/rust.vim'
" Swift
Plug 'keith/swift.vim'
" Golang
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
call plug#end()

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

"" LANGUAGE CLIENT
let g:LanguageClient_serverCommands = {
      \ 'python': ['pyls'],
      \ }

let g:LanguageClient_settingsPath = "~/.config/nvim/language-client/settings.json"

" Apply mappings only for buffers with supported filetypes
function LC_maps()
  if has_key(g:LanguageClient_serverCommands, &filetype)
    nnoremap <silent> K :call LanguageClient_contextMenu()<CR>
    nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
    nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
    nnoremap <silent> gr :call LanguageClient#textDocument_references()<CR>
  endif
endfunction
autocmd FileType * call LC_maps()

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

"" RAINBOW PARANTHESES
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

let g:rbpt_colorpairs = [
      \ ['brown',       'RoyalBlue3'],
      \ ['Darkblue',    'SeaGreen3'],
      \ ['darkgray',    'DarkOrchid3'],
      \ ['darkgreen',   'firebrick3'],
      \ ['darkcyan',    'RoyalBlue3'],
      \ ['darkred',     'SeaGreen3'],
      \ ['darkmagenta', 'DarkOrchid3'],
      \ ['brown',       'firebrick3'],
      \ ['gray',        'RoyalBlue3'],
      \ ['darkmagenta', 'DarkOrchid3'],
      \ ['Darkblue',    'firebrick3'],
      \ ['darkgreen',   'RoyalBlue3'],
      \ ['darkcyan',    'SeaGreen3'],
      \ ['darkred',     'DarkOrchid3'],
      \ ]

"" LANGUAGE-SPECIFIC

" LaTeX: default latexmk options for vimtex
let g:vimtex_latexmk_options = '-pdf -shell-escape -verbose -file-line-error -synctex=1 -interaction=nonstopmode'
" Deoplete for LaTeX
if !exists('g:deoplete#omni#input_patterns')
  let g:deoplete#omni#input_patterns = {}
endif
let g:deoplete#omni#input_patterns.tex = g:vimtex#re#deoplete
" Don't open quickfix
let g:vimtex_quickfix_mode = 0

" Swift: use 4 spaces
autocmd FileType swift setlocal shiftwidth=4 tabstop=4

" Typescript: linebreak at 100 chars and use ES2015
autocmd FileType typescript setlocal cc=101
let g:typescript_compiler_options = '--target ES6'

" Set some colors for Typescript JSX
hi tsxTagName ctermfg=DarkRed
hi tsxCloseString ctermfg=Blue
hi tsxCloseTag ctermfg=Blue
hi tsxAttributeBraces ctermfg=Blue
hi tsxEqual ctermfg=Blue
hi tsxAttrib ctermfg=Yellow

" C: use 4 spaces
autocmd FileType c setlocal shiftwidth=4 tabstop=4

" Rust: don't use recommendation of 4 spcaes
let g:rust_recommended_style = 0

" Golang: use tabs
autocmd FileType go setlocal noexpandtab
