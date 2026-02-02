"" PLUGINS
call plug#begin()
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
" File browser in sidebar
Plug 'scrooloose/nerdtree'
" Quoting/parenthesizing made simple
Plug 'tpope/vim-surround'
" Auto add `end` on Ruby etc.
Plug 'tpope/vim-endwise'
" Treesitter
Plug 'nvim-treesitter/nvim-treesitter'
" LSP
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
" Telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' }

Plug 'davidmh/mdx.nvim'
call plug#end()

lua <<EOF
  -- Use 2 spaces and some magic
  vim.opt.tabstop = 2
  vim.opt.softtabstop = 0
  vim.opt.shiftwidth = 2
  -- Expand tabs into spaces
  vim.opt.expandtab = true
  -- Except for golang, authzed
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'go', 'authzed' },
    callback = function()
      vim.opt.expandtab = false
    end,
  })
  -- SQL files use 4 spaces
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'sql',
    callback = function()
      vim.opt.tabstop = 4
      vim.opt.shiftwidth = 4
    end,
  })
  -- Add line marker at 81th character
  vim.opt.colorcolumn = "81"
  -- Show line numbers
  vim.opt.number = true
  -- Process syntax indefinitely
  vim.opt.synmaxcol = 0

  vim.opt.hidden = false

  -- Set undo files and backup files in ~/.vimtmp
  vim.opt.backup = true
  vim.opt.undofile = true
  vim.opt.backupdir = { vim.fn.expand('~/.vimtmp'), '.' }
  vim.opt.directory = { vim.fn.expand('~/.vimtmp'), '.' }
  vim.opt.undodir = { vim.fn.expand('~/.vimtmp'), '.' }

  -- Disable mouse
  vim.opt.mouse = ''

  -- Make Y behave like y instead of y$
  vim.keymap.set('n', 'Y', 'y')

  -- On `:set list` show space with ␣ and tab with >·
  vim.opt.listchars = { tab = '>·', space = '␣' }

  -- Use \ as local leader, for LaTeX etc.
  vim.g.maplocalleader = '\\'

  -- C-<char> maps
  vim.keymap.set("n", "<C-c>", ":cclose<CR>")
  vim.keymap.set({ "n", "v" }, "<C-j>", "5j")
  vim.keymap.set({ "n", "v" }, "<C-k>", "5k")

  -- CMP
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
    }),
    preselect = cmp.PreselectMode.None,
  })

  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
  })

  -- NVIM LSP
  local capabilities = require('cmp_nvim_lsp').default_capabilities()

  vim.lsp.config('pyright', {
    capabilities = capabilities,
  })
  vim.lsp.config('ruff', {
    capabilities = capabilities,
  })
  vim.lsp.config('ts_ls', {
    capabilities = capabilities,
    on_attach = function(client, bufnr)
      vim.lsp.buf_notify(bufnr, "workspace/didChangeConfiguration", {
        settings = {
          typescript = {
            format = {
              convertTabsToSpaces = false
            }
          }
        }
      })
    end,
  })
  vim.lsp.config('clangd', { capabilities = capabilities })
  vim.lsp.config('rust_analyzer', { capabilities = capabilities })
  vim.lsp.config('gopls', { capabilities = capabilities })

  vim.lsp.enable({ 'pyright', 'ruff', 'ts_ls', 'clangd', 'rust_analyzer', 'gopls' })

  -- Make LSP support jump to definition
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client.supports_method('textDocument/definition') then
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
      end
      if client.supports_method('textDocument/references') then
        vim.keymap.set('n', 'gr', vim.lsp.buf.references)
      end
    end,
  })

  vim.api.nvim_create_autocmd('VimEnter', {
    callback = function()
      vim.g["airline#extensions#nvimlsp#enabled"] = 0
      vim.diagnostic.enable(false)
    end,
  })
  vim.keymap.set('n', '<C-n>', function()
    vim.diagnostic.enable(not vim.diagnostic.is_enabled())
  end)
  vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function()
      vim.lsp.buf.format({ async = false })
    end
  })

  -- TELESCOPE
  local builtin = require('telescope.builtin')
  vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
  vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
  vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
  vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

  -- TREESITTER
  vim.api.nvim_create_autocmd('FileType', {
    callback = function() pcall(vim.treesitter.start) end,
  })

  -- NERDTREE
  vim.api.nvim_create_autocmd("VimEnter", {
    command = "NERDTree",
  })
  vim.g.NERDTreeIgnore = { '\\.pyc$', '__pycache__' }
  vim.keymap.set("n", "<Space>", ":NERDTreeFind<CR>")

  -- AUTOPAIRS
  vim.g.AutoPairsShortcutToggle = ''

  -- BASE16 - vim/terminal color scheme
  vim.g.base16colorspace = 256
  vim.cmd.colorscheme("base16-dracula")
EOF

let airline#extensions#nvimlsp#enabled = 0
