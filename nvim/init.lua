-----------------------------------------------------------
-- Minimal, fast Neovim config focused on speed and highlighting
-----------------------------------------------------------

-----------------------------------------------------------
-- Bootstrapping lazy.nvim
-----------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-----------------------------------------------------------
-- General settings
-----------------------------------------------------------
vim.o.number = true
vim.o.relativenumber = true

-- tabs / spaces
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 4
vim.opt.expandtab = false      -- <- pick true/false here as you prefer

vim.o.smartindent = true
vim.o.termguicolors = true
vim.o.updatetime = 200
vim.o.cursorline = true

-- Set tab width (optional)
vim.opt.tabstop = 4       -- how wide a real tab looks
vim.opt.shiftwidth = 4    -- how many columns >> indents
vim.opt.softtabstop = 4   -- how <Tab> acts in insert mode

-- Leader
vim.keymap.set('n', '<Space>', '<Nop>', { silent = true })
vim.g.mapleader = ' '

-- Disable arrow keys in normal mode
vim.keymap.set('n', '<Up>', '<Nop>')
vim.keymap.set('n', '<Down>', '<Nop>')
vim.keymap.set('n', '<Left>', '<Nop>')
vim.keymap.set('n', '<Right>', '<Nop>')

-- Disable arrow keys in insert mode
vim.keymap.set('i', '<Up>', '<Nop>')
vim.keymap.set('i', '<Down>', '<Nop>')
vim.keymap.set('i', '<Left>', '<Nop>')
vim.keymap.set('i', '<Right>', '<Nop>')

-- ESC shortcut
vim.keymap.set('i', 'jk', '<Esc>')

-- Enable list mode
vim.opt.list = true

-- Define characters
vim.opt.listchars = {
  tab = "->",
  space = ".",
  trail = ".",
}

-----------------------------------------------------------
-- Diagnostic inline errors (PUT IT HERE)
-----------------------------------------------------------
vim.diagnostic.config({
  virtual_text = {
    prefix = "●",
    spacing = 2,
  },
  signs = true,
  underline = true,
  update_in_insert = false,
})

--Error MSG Customization
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = "#ff6c6b", bg = "NONE", italic = true })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn",  { fg = "#ECBE7B", bg = "NONE", italic = true })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo",  { fg = "#51afef", bg = "NONE", italic = true })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint",  { fg = "#98be65", bg = "NONE", italic = true })

-----------------------------------------------------------
-- Plugins
-----------------------------------------------------------
require('lazy').setup({

  -----------------------------------------------------------
  -- Color scheme
  -----------------------------------------------------------
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme tokyonight]])
    end,
  },

  -----------------------------------------------------------
  -- Treesitter
  -----------------------------------------------------------
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        highlight = { enable = true },
        indent = { enable = true },
        ensure_installed = {
          'lua', 'python', 'javascript', 'typescript', 'bash', 'json',
          'html', 'css', 'c', 'cpp', 'go', 'rust','make',
        },
      })
    end,
  },

  -----------------------------------------------------------
  -- Oil (file explorer)
  -----------------------------------------------------------
  {
    "stevearc/oil.nvim",
    opts = {},
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  -----------------------------------------------------------
  -- LSP + Autocompletion
  -----------------------------------------------------------
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',

      'L3MON4D3/LuaSnip',
      'rafamadriz/friendly-snippets',
    },

    config = function()
      -------------------------------------------------------
      -- LuaSnip
      -------------------------------------------------------
      require("luasnip.loaders.from_vscode").lazy_load()

      -------------------------------------------------------
      -- nvim-cmp setup
      -------------------------------------------------------
      local cmp = require('cmp')
      local luasnip = require('luasnip')

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        mapping = cmp.mapping.preset.insert({
          ['<CR>'] = cmp.mapping.confirm({ select = true }),

          ['<Tab>'] = cmp.mapping(function(fallback)

            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),

          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),

        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
        }),
      })

      -------------------------------------------------------
      -- LSP servers
      -------------------------------------------------------
      local lspconfig = require('lspconfig')
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
	  vim.lsp.inlay_hint.enable(true)

      -- C/C++ via clangd
      lspconfig.clangd.setup({
        capabilities = capabilities,
		cmd = {
				"clangd",
				"--background-index",
				 "--completion-style=detailed",
				 "--header-insertion=never",
				}
      })
    end,
  },

  -----------------------------------------------------------
  -- File explorer (nvim-tree)
  -----------------------------------------------------------
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = 'nvim-tree/nvim-web-devicons',

    config = function()
      local function my_on_attach(bufnr)
        local api = require('nvim-tree.api')

        -- Default mappings
        api.config.mappings.default_on_attach(bufnr)

        local function opts(desc)
          return {
            desc = 'nvim-tree: ' .. desc,
            buffer = bufnr,
            noremap = true,
            silent = true,
            nowait = true,
          }
        end

        -----------------------------------------------------------
        -- Navigation (netrw-style)
        -----------------------------------------------------------
        vim.keymap.set('n', 'L', api.node.open.edit, opts('Open'))
        vim.keymap.set('n', 'H', api.node.navigate.parent_close, opts('Close directory'))
        vim.keymap.set('n', 'l', api.node.open.no_window_picker, opts('Open without picker'))

        -----------------------------------------------------------
        -- Splits & tabs
        -----------------------------------------------------------
        vim.keymap.set('n', 'S', api.node.open.horizontal, opts('Horizontal split'))
        vim.keymap.set('n', 'V', api.node.open.vertical,   opts('Vertical split'))
        vim.keymap.set('n', 'T', api.node.open.tab,        opts('Open in new tab'))
        vim.keymap.set('n', 'P', api.node.open.preview,    opts('Preview'))

        -----------------------------------------------------------
        -- File ops
        -----------------------------------------------------------
        vim.keymap.set('n', 'A', api.fs.create,           opts('Create'))
        vim.keymap.set('n', 'D', api.fs.remove,           opts('Delete'))
        vim.keymap.set('n', 'R', api.fs.rename,           opts('Rename'))
        vim.keymap.set('n', 'X', api.fs.cut,              opts('Cut'))
        vim.keymap.set('n', 'C', api.fs.copy.node,        opts('Copy'))
        vim.keymap.set('n', 'P', api.fs.paste,            opts('Paste'))
        vim.keymap.set('n', 'Y', api.fs.copy.filename,    opts('Copy name'))
        vim.keymap.set('n', 'y', api.fs.copy.relative_path, opts('Copy relative path'))
        vim.keymap.set('n', 'gY', api.fs.copy.absolute_path, opts('Copy absolute path'))

        -----------------------------------------------------------
        -- Tree actions
        -----------------------------------------------------------
        vim.keymap.set('n', 'r', api.tree.reload,                      opts('Refresh'))
        vim.keymap.set('n', 'h', api.tree.toggle_hidden_filter,        opts('Toggle hidden'))
        vim.keymap.set('n', 'i', api.tree.toggle_gitignore_filter,     opts('Toggle gitignore'))
        vim.keymap.set('n', 'e', api.tree.expand_all,                  opts('Expand all'))
        vim.keymap.set('n', 'w', api.tree.collapse_all,                opts('Collapse all'))

        -----------------------------------------------------------
        -- Misc
        -----------------------------------------------------------
        vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
        vim.keymap.set('n', 'Q', api.tree.close,       opts('Close'))
      end

      require('nvim-tree').setup({
        on_attach = my_on_attach,
      })

      -- Toggle tree
      vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { silent = true })
    end,
  },

  -----------------------------------------------------------
  -- Telescope
  -----------------------------------------------------------
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.4',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local telescope_builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>f', telescope_builtin.find_files)
      vim.keymap.set('n', '<leader>g', telescope_builtin.live_grep)
    end,
  },

  -----------------------------------------------------------
  -- Trouble (diagnostics / quickfix list)
  -----------------------------------------------------------
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      use_diagnostic_signs = true, -- use builtin LSP signs
    },
    config = function(_, opts)
      require("trouble").setup(opts)

      -- Keymaps for Trouble
      local trouble = require("trouble")

      -- Toggle document diagnostics
      vim.keymap.set("n", "<leader>xx", function()
        trouble.toggle("diagnostics")
      end, { desc = "Trouble: diagnostics (workspace)" })

      -- Buffer-local diagnostics
      vim.keymap.set("n", "<leader>xb", function()
        trouble.toggle("diagnostics", { filter = { buf = 0 } })
      end, { desc = "Trouble: diagnostics (buffer)" })

      -- Quickfix
      vim.keymap.set("n", "<leader>xq", function()
        trouble.toggle("qflist")
      end, { desc = "Trouble: quickfix list" })

      -- LSP references (if you use them a lot)
      vim.keymap.set("n", "<leader>xr", function()
        trouble.toggle("lsp_references")
      end, { desc = "Trouble: LSP references" })
    end,
  },

})

