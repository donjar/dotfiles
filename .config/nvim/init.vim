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
" Process syntax indefinitely
set synmaxcol=0
" Prevent closing window if it is unsaved
set nohidden

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

" C-<char> maps
nnoremap <C-n> :noh<CR>
nnoremap <C-j> 5j
nnoremap <C-k> 5k
vnoremap <C-j> 5j
vnoremap <C-k> 5k

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
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
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
" Q#
Plug 'gootorov/q-sharp.vim'
" Terraform
Plug 'hashivim/vim-terraform'
" GraphQL
Plug 'jparise/vim-graphql'
call plug#end()

au VimEnter * delcommand Files
au VimEnter * delcommand Filetypes

"" NEOVIM
" Escape terminal
tnoremap <esc> <C-\><C-n>

"" FZF
" Call grep on current selected word
nnoremap <silent> gf :call fzf#vim#grep("grep -rnw --exclude-dir=.git --color=always " . expand("<cword>") . " .", 1)<CR>

"" NERDTREE - file browser in sidebar
" Enter NERDTree on start
autocmd VimEnter * :NERDTree

let NERDTreeIgnore = ['\.pyc$', '__pycache__']
nnoremap <Space> :NERDTreeFind<CR>

"" BASE16 - vim/terminal color scheme
let base16colorspace = 256
colorscheme base16-dracula

"" LANGUAGE CLIENT
let g:LanguageClient_serverCommands = {
    \ 'python': ['pylsp', '--log-file', '/tmp/pylsp.txt'],
    \ 'typescript': ['typescript-language-server', '--stdio'],
    \ 'typescript.tsx': ['typescript-language-server', '--stdio'],
    \ 'typescriptreact': ['typescript-language-server', '--stdio'],
    \ 'javascript': ['typescript-language-server', '--stdio'],
    \ 'javascript.jsx': ['typescript-language-server', '--stdio'],
    \ 'rust': ['rust-analyzer'],
    \ 'cpp': ['clangd'],
    \ }

let g:LanguageClient_diagnosticsEnable = 0
let g:LanguageClient_loggingFile = '/tmp/LanguageClient.log'

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
" Don't show preview window
set completeopt-=preview

"" AUTOPAIRS
let g:AutoPairsShortcutToggle = ''

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
call deoplete#custom#var('omni', 'input_patterns', {
      \ 'tex' : g:vimtex#re#deoplete,
\})
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

" Python: linebreak at 88 chars, like Black
autocmd FileType python setlocal cc=89

" C: use 4 spaces
autocmd FileType c setlocal shiftwidth=4 tabstop=4

" Golang: use tabs
autocmd FileType go setlocal noexpandtab

" Q#: use 4 spaces
autocmd FileType qs setlocal shiftwidth=4 tabstop=4

" XML
let g:xml_syntax_folding=1
autocmd FileType xml setlocal foldmethod=syntax
