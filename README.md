🚀 Minimal Fast Neovim Configuration
This repository contains a minimal, fast, and modern Neovim setup focused on:
⚡ Speed
🎨 Beautiful UI
🌳 Treesitter-based syntax highlighting
🧠 LSP + Autocompletion
📁 Easy file navigation (NvimTree)
🔍 Search & fuzzy finding (Telescope)
Everything is configured through lazy.nvim, providing clean plugin management and fast startup times.
✨ Features
🔧 General Editing Enhancements
Relative & absolute line numbers
Smart indentation
Highlighted cursor line
List mode with visible whitespace (tabs → ->, spaces → ., trailing → .)
ESC shortcut: press jk in insert mode
Arrow keys disabled (encourages hjkl navigation)
🎨 UI & Colors
Tokyonight colorscheme (no lazy-loading → loads instantly)
🌳 Treesitter
Faster, more accurate syntax highlighting
Auto-indentation
Ensures essential language parsers are installed (Lua, Python, C, C++, Go, Rust, TS, HTML, CSS, JSON…)
🧠 LSP + Autocompletion
clangd LSP preconfigured (C/C++)
Completion via:
nvim-cmp
Snippets with LuaSnip + friendly-snippets
<Tab> / <S-Tab> snippet navigation
<CR> to confirm selections
📁 File Explorer (NvimTree)
Custom keybindings:
Action	Key
Open file	l
Close directory	h
Horizontal split	s
Vertical split	v
New tab	t
Refresh	R
Toggle tree	<leader>e
Includes full file operations: create, delete, rename, copy, paste, etc.
🔍 Telescope Integration
<leader>f → Find files
<leader>g → Live grep
