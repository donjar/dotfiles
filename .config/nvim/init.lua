-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Use 2 spaces
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

-- Add line marker at 81st character
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

-- PLUGINS
require("lazy").setup({
  -- Pretty status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = { options = { theme = "dracula" } },
  },

  -- base16 color scheme
  {
    "chriskempson/base16-vim",
    config = function()
      vim.g.base16colorspace = 256
      vim.cmd.colorscheme("base16-dracula")
      vim.api.nvim_set_hl(0, "PmenuSel", { ctermbg = 2, ctermfg = 0, reverse = true })
    end,
  },

  -- File browser in sidebar
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local tree_expanded = false
      require("nvim-tree").setup({
        filters = { dotfiles = true },
        on_attach = function(bufnr)
          local api = require("nvim-tree.api")
          api.config.mappings.default_on_attach(bufnr)
          vim.keymap.set("n", "<C-c>", api.tree.change_root_to_node, { buffer = bufnr, desc = "CD" })
          vim.keymap.set("n", "A", function()
            if tree_expanded then
              vim.cmd("NvimTreeResize 30")
            else
              vim.cmd("NvimTreeResize " .. vim.o.columns)
            end
            tree_expanded = not tree_expanded
          end, { buffer = bufnr, desc = "Toggle Zoom" })
        end,
      })
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function() require("nvim-tree.api").tree.open() end,
      })
      vim.keymap.set("n", "<Space>", ":NvimTreeFindFile<CR>")
    end,
  },

  -- Show git diff in gutter
  { "lewis6991/gitsigns.nvim", opts = {} },

  -- Auto close parantheses
  {
    "jiangmiao/auto-pairs",
    config = function()
      vim.g.AutoPairsShortcutToggle = ''
    end,
  },

  -- Quoting/parenthesizing made simple
  { "tpope/vim-surround" },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      vim.api.nvim_create_autocmd('FileType', {
        callback = function() pcall(vim.treesitter.start) end,
      })
    end,
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      vim.lsp.config('pyright', { capabilities = capabilities })
      vim.lsp.config('ruff', { capabilities = capabilities })
      vim.lsp.config('ts_ls', {
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          vim.lsp.buf_notify(bufnr, "workspace/didChangeConfiguration", {
            settings = { typescript = { format = { convertTabsToSpaces = false } } },
          })
        end,
      })
      vim.lsp.config('clangd', { capabilities = capabilities })
      vim.lsp.config('rust_analyzer', { capabilities = capabilities })
      vim.lsp.config('gopls', { capabilities = capabilities })

      vim.lsp.enable({ 'pyright', 'ruff', 'ts_ls', 'clangd', 'rust_analyzer', 'gopls' })

      -- Jump to definition / references
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

      -- Diagnostics disabled by default, toggle with C-n
      vim.diagnostic.config({ virtual_text = true })
      vim.api.nvim_create_autocmd('VimEnter', {
        callback = function() vim.diagnostic.enable(false) end,
      })
      vim.keymap.set('n', '<C-n>', function()
        vim.diagnostic.enable(not vim.diagnostic.is_enabled())
      end)

      -- Format on save
      vim.api.nvim_create_autocmd("BufWritePre", {
        callback = function() vim.lsp.buf.format({ async = false }) end,
      })
    end,
  },

  -- CMP
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
    },
    config = function()
      local cmp = require('cmp')
      cmp.setup({
        snippet = {
          expand = function(args) vim.snippet.expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<Tab>'] = cmp.mapping.select_next_item(),
          ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        }),
        sources = cmp.config.sources(
          { { name = 'nvim_lsp' } },
          { { name = 'buffer' } }
        ),
        preselect = cmp.PreselectMode.None,
      })
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = 'buffer' } },
      })
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources(
          { { name = 'path' } },
          { { name = 'cmdline' } }
        ),
        matching = { disallow_symbol_nonprefix_matching = false },
      })
    end,
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release" },
    },
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files)
      vim.keymap.set('n', '<leader>fg', builtin.live_grep)
      vim.keymap.set('n', '<leader>fb', builtin.buffers)
      vim.keymap.set('n', '<leader>fh', builtin.help_tags)
    end,
  },
})
