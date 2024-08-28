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
" Fuzzy finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" File browser in sidebar
Plug 'scrooloose/nerdtree'
" Quoting/parenthesizing made simple
Plug 'tpope/vim-surround'
" Auto add `end` on Ruby etc.
Plug 'tpope/vim-endwise'
" Colorful parans
Plug 'kien/rainbow_parentheses.vim'

Plug 'nvim-treesitter/nvim-treesitter'

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

Plug 'zbirenbaum/copilot.lua'
call plug#end()

au VimEnter * delcommand Files
au VimEnter * delcommand Filetypes

lua <<EOF
  local cmp = require('cmp')

  cmp.setup({
    snippet = {
      expand = function(args)
        vim.snippet.expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ['<Tab>'] = cmp.mapping.select_next_item(),
      ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
  })

  -- Set up lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  local lspconfig = require('lspconfig')
  lspconfig.pylsp.setup({})
  lspconfig.tsserver.setup({})
  lspconfig.clangd.setup({})
  lspconfig.rust_analyzer.setup({})
  lspconfig.gopls.setup({})

  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client.supports_method('textDocument/definition') then
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
      end
    end,
  })

  vim.diagnostic.config({
    virtual_text = false,
    signs = false,
    underline = false,
  })

  require('copilot').setup({
    suggestion = {
      keymap = {
        accept = "<right>",
      }
    }
  })
  vim.keymap.set('i', '<C-Space>', require('copilot.suggestion').next)
EOF

autocmd BufWritePre *.go lua vim.lsp.buf.format({ async = false })
autocmd BufWritePre *.ts lua vim.lsp.buf.format({ async = false })
autocmd BufWritePre *.py lua vim.lsp.buf.format({ async = false })

let g:airline#extensions#nvimlsp#enabled = 0

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
