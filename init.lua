-- Minimal, fast Neovim config focused on speed and code highlighting

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
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 4
vim.opt.expandtab = false
vim.o.smartindent = true
vim.o.termguicolors = true
vim.o.updatetime = 200
vim.o.cursorline = true

-- Set tab width (optional)
vim.opt.tabstop = 4       -- how wide a real tab looks
vim.opt.shiftwidth = 4    -- how many columns >> indents
vim.opt.softtabstop = 4   -- how TAB acts in insert mode

vim.keymap.set('n', '<Space>', '<Nop>', { silent = true })
vim.g.mapleader = ' '

-- Disable Arrow Keys
vim.keymap.set('n', '<Up>', '<Nop>')
vim.keymap.set('n', '<Down>', '<Nop>')
vim.keymap.set('n', '<Left>', '<Nop>')
vim.keymap.set('n', '<Right>', '<Nop>')

-- Disable arrow keys in insert mode
vim.keymap.set('i', '<Up>', '<Nop>')
vim.keymap.set('i', '<Down>', '<Nop>')
vim.keymap.set('i', '<Left>', '<Nop>')
vim.keymap.set('i', '<Right>', '<Nop>')

-- ESC Shortcut
vim.keymap.set("i", "jk", "<Esc>")

-- Enable list mode
vim.opt.list = true

-- Define characters
vim.opt.listchars = {
    tab = "->",
    space = ".",
    trail = "."
}


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
          'html', 'css', 'c', 'cpp', 'go', 'rust'
        }
      })
    end,
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

      -- Install C/C++ only (clangd)
      lspconfig.clangd.setup({
        capabilities = capabilities,
      })
    end,
  },

  -----------------------------------------------------------
  -- File explorer (NvimTree)
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
        -- Navigation (netrw style)
        -----------------------------------------------------------
        vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))
        vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts('Close Directory'))
        vim.keymap.set('n', 'L', api.node.open.no_window_picker, opts('Open Without Picker'))

        -----------------------------------------------------------
        -- Splits & tabs
        -----------------------------------------------------------
        vim.keymap.set('n', 's', api.node.open.horizontal, opts('Horizontal Split'))
        vim.keymap.set('n', 'v', api.node.open.vertical,   opts('Vertical Split'))
        vim.keymap.set('n', 't', api.node.open.tab,        opts('Open in New Tab'))
        vim.keymap.set('n', 'p', api.node.open.preview,    opts('Preview'))

        -----------------------------------------------------------
        -- File ops
        -----------------------------------------------------------
        vim.keymap.set('n', 'a', api.fs.create, opts('Create'))
        vim.keymap.set('n', 'd', api.fs.remove, opts('Delete'))
        vim.keymap.set('n', 'r', api.fs.rename, opts('Rename'))
        vim.keymap.set('n', 'x', api.fs.cut, opts('Cut'))
        vim.keymap.set('n', 'c', api.fs.copy.node, opts('Copy'))
        vim.keymap.set('n', 'p', api.fs.paste, opts('Paste'))
        vim.keymap.set('n', 'y', api.fs.copy.filename, opts('Copy Name'))
        vim.keymap.set('n', 'Y', api.fs.copy.relative_path, opts('Copy Relative Path'))
        vim.keymap.set('n', 'gy', api.fs.copy.absolute_path, opts('Copy Absolute Path'))

        -----------------------------------------------------------
        -- Tree actions
        -----------------------------------------------------------
        vim.keymap.set('n', 'R', api.tree.reload, opts('Refresh'))
        vim.keymap.set('n', 'H', api.tree.toggle_hidden_filter, opts('Toggle Hidden'))
        vim.keymap.set('n', 'I', api.tree.toggle_gitignore_filter, opts('Toggle Gitignore'))
        vim.keymap.set('n', 'E', api.tree.expand_all, opts('Expand All'))
        vim.keymap.set('n', 'W', api.tree.collapse_all, opts('Collapse All'))

        -----------------------------------------------------------
        -- Misc
        -----------------------------------------------------------
        vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
        vim.keymap.set('n', 'q', api.tree.close, opts('Close'))
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
      local telescope = require('telescope.builtin')
      vim.keymap.set('n', '<leader>f', telescope.find_files)
      vim.keymap.set('n', '<leader>g', telescope.live_grep)
    end,
  },

})

