# 🌙 Minimal & Fast Neovim Configuration  
A lightweight Neovim setup focused on **speed**, **clean UI**, **Treesitter**, **LSP**, and **modern editing comfort** — powered by **lazy.nvim**.

---

## ✨ Features Overview

### 🔧 Editor Enhancements
- Hybrid line numbers  
- Smart indentation & tab control  
- Cursorline enabled  
- Visible whitespace (tabs `->`, spaces `.`, trailing `.`)  
- `jk` → fast escape  
- Arrow keys disabled (train your hjkl!)

---

## 🎨 UI & Colors
- **Tokyonight** colorscheme (loaded instantly, no lazy-loading)  
- True color support enabled

---

## 🌳 Treesitter
Powered by `nvim-treesitter`:

- Fast, accurate syntax highlighting  
- Automatic indentation  
- Automatic parser installation for:  
  `lua`, `python`, `javascript`, `typescript`,  
  `bash`, `json`, `html`, `css`,  
  `c`, `cpp`, `go`, `rust`

---

## 🧠 LSP + Autocompletion

### LSP
- Preconfigured **clangd** (C & C++)  
- Enhanced LSP capabilities via `cmp_nvim_lsp`

### Completion (nvim-cmp)
- Snippets with **LuaSnip**  
- `<Tab>` / `<S-Tab>` to navigate items or jump through snippets  
- `<CR>` to confirm selections  
- Completion sources:
  - LSP  
  - Snippets  
  - Buffer  
  - Path  

---

## 📁 File Explorer (NvimTree)

Custom fast navigation inspired by netrw:

| Action | Key |
|--------|-----|
| Open file | `l` |
| Close parent directory | `h` |
| Open horizontal split | `s` |
| Open vertical split | `v` |
| Open in new tab | `t` |
| Reload | `R` |
| Toggle hidden files | `H` |
| Toggle `.gitignore` filter | `I` |
| Expand all | `E` |
| Collapse all | `W` |
| Toggle tree | `<leader>e` |

Includes full file operations: create, delete, rename, cut, copy, paste.

---

## 🔍 Telescope (Fuzzy Finder)

| Action | Key |
|--------|-----|
| Search files | `<leader>f` |
| Live grep | `<leader>g` |

Powered by `telescope.nvim` + `plenary.nvim`.

---

## ⌨️ Keybinding Summary

### Leader Key
