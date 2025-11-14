# Neovim Configuration

Modern Neovim configuration with LSP support, file navigation, and productivity enhancements.

## Overview

This configuration uses [lazy.nvim](https://github.com/folke/lazy.nvim) as the plugin manager and focuses on:
- Language Server Protocol (LSP) integration for multiple languages
- Modern UI with statusline, bufferline, and file trees
- Fuzzy finding with Telescope
- Git integration
- Terminal integration

**Leader key:** `<Space>`

---

## Plugins

### UI/UX

#### [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)
Modern statusline showing mode, git branch, file path, LSP diagnostics, and cursor position.
- Theme: tokyonight
- Shows relative file paths
- Displays LSP diagnostic counts

#### [bufferline.nvim](https://github.com/akinsho/bufferline.nvim)
Buffer tabs at the top of the window with ordinal numbers for quick jumping.
- Shows buffers as numbered tabs (1-9)
- Excludes terminal and NvimTree buffers
- Click to switch buffers, close with mouse

#### [tokyonight.nvim](https://github.com/folke/tokyonight.nvim)
Current colorscheme providing consistent theming across UI elements.

#### [which-key.nvim](https://github.com/folke/which-key.nvim)
Displays available keybindings in a popup as you type.

### File Navigation

#### [nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua)
Sidebar file explorer (default file browser).
- Opens on left side (35 columns wide)
- Git integration with file status indicators
- Shows hidden files
- Replaces netrw

#### [oil.nvim](https://github.com/stevearc/oil.nvim)
Alternative file browser using buffer-based editing.
- Edit directories like regular buffers
- Shows hidden files
- Good for quick file operations

#### [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
Fuzzy finder for files, text, buffers, and help.
- Uses FZF for fast fuzzy searching
- Dropdown theme for all pickers
- Smart path display
- Buffer picker with MRU sorting

### Git Integration

#### [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)
Git decorations and inline blame information.

### Terminal

#### [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim)
Integrated terminal inside Neovim.
- Vertical split by default (60 columns)
- Persistent size
- Starts in insert mode

### Code Editing

#### [Comment.nvim](https://github.com/numToStr/Comment.nvim)
Smart commenting plugin with language-aware support.
- Toggle line comments with `gcc`
- Toggle block comments with `gbc`
- Operator-pending mode with `gc` (line) and `gb` (block)
- Works with treesitter for proper comment syntax

**Command naming:** The `gc` and `gb` prefixes follow Vim's convention of using `g` for "go" or additional operations (like `gd` for go-to-definition). Here `gc` means "go comment" for line comments, and `gb` means "go block" for block comments.

### Language Support

#### [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
Advanced syntax highlighting and code understanding using AST parsing.

**Supported languages:**
- Lua, Vim, Python
- TypeScript, JavaScript, TSX, JSON
- Java, C#
- HTML, CSS
- YAML, Dockerfile, Bash
- Markdown, SQL, Regex

#### LSP Configuration

**Mason** - LSP server installer and manager
- [mason.nvim](https://github.com/williamboman/mason.nvim)
- [mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim)

**LSP Servers:**
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - Core LSP configuration
- [roslyn.nvim](https://github.com/seblyng/roslyn.nvim) - C# / .NET LSP (Roslyn)
- [nvim-jdtls](https://github.com/mfussenegger/nvim-jdtls) - Java LSP (Eclipse JDTLS)

### Completion

#### [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)
Autocompletion engine with multiple sources.

**Sources:**
- LSP completions (via cmp-nvim-lsp)
- Snippets (via LuaSnip)
- Buffer text
- File paths

**Snippets:**
- [LuaSnip](https://github.com/L3MON4D3/LuaSnip) - Snippet engine
- [friendly-snippets](https://github.com/rafamadriz/friendly-snippets) - Collection of snippets for many languages

---

## Keymaps

### Terminal Mode
| Key | Action | Description |
|-----|--------|-------------|
| `<Esc><Esc>` | Exit terminal mode | Return to normal mode |

### Diagnostics
| Key | Action | Description |
|-----|--------|-------------|
| `gl` | Open diagnostic float | Show diagnostic for current line |

### LSP Navigation
| Key | Action | Description |
|-----|--------|-------------|
| `grd` | Go to definition | Jump to symbol definition |
| `grD` | Go to declaration | Jump to symbol declaration |

### File Explorers
| Key | Action | Description |
|-----|--------|-------------|
| `<leader>e` | Toggle NvimTree | Open/close file tree sidebar |
| `<leader>o` | Open Oil | Open Oil file browser |

### Window Navigation
| Key | Action | Description |
|-----|--------|-------------|
| `<C-h>` | Move left | Focus left window |
| `<C-j>` | Move down | Focus bottom window |
| `<C-k>` | Move up | Focus top window |
| `<C-l>` | Move right | Focus right window |

### Window Management (Splits)
| Key | Action | Description |
|-----|--------|-------------|
| `<C-w>v` | Vertical split | Split window vertically |
| `<C-w>s` | Horizontal split | Split window horizontally |
| `<C-w>q` | Close window | Close current split window |
| `<C-w>o` | Only window | Close all other windows |
| `<C-w>=` | Equalize windows | Make all windows equal size |
| `:vsplit` | Vertical split | Command mode vertical split |
| `:split` | Horizontal split | Command mode horizontal split |
| `:q` | Quit window | Close current window |
| `:only` | Only window | Close all other windows |

### Buffer Management
| Key | Action | Description |
|-----|--------|-------------|
| `<S-h>` | Previous buffer | Cycle to previous buffer |
| `<S-l>` | Next buffer | Cycle to next buffer |
| `<leader>bd` | Delete buffer | Smart buffer delete |
| `<leader>bc` | Pick buffer to close | Interactive buffer close |
| `<leader>1` - `<leader>9` | Jump to buffer N | Jump to buffer by number |

### Telescope (Fuzzy Finder)
| Key | Action | Description |
|-----|--------|-------------|
| `<leader>ff` | Find files | Search for files in project |
| `<leader>fg` | Live grep | Search text in project |
| `<leader>fb` | Find buffers | Search open buffers |
| `<leader>fh` | Help tags | Search help documentation |

**Telescope buffer picker shortcuts:**
- `d` (normal mode) - Delete selected buffer
- `<C-d>` (insert mode) - Delete selected buffer

### Terminal
| Key | Action | Description |
|-----|--------|-------------|
| `<C-\>` | Toggle terminal | Open/close integrated terminal |

### Indentation
| Mode | Key | Action |
|------|-----|--------|
| Insert | `<S-Tab>` | Unindent current line |
| Visual | `<S-Tab>` | Unindent selection (keeps selection) |
| Normal | `<S-Tab>` | Unindent current line |

### Commenting
| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| Normal | `gcc` | Toggle comment | Comment/uncomment current line |
| Normal | `gbc` | Toggle block comment | Comment/uncomment as block |
| Normal/Visual | `gc` + motion | Line comment | Comment using motion (e.g., `gcap` for paragraph) |
| Normal/Visual | `gb` + motion | Block comment | Block comment using motion |
| Visual | `gc` | Line comment | Comment selected lines |
| Visual | `gb` | Block comment | Comment selection as block |

### Completion (Insert Mode)
| Key | Action | Description |
|-----|--------|-------------|
| `<Tab>` | Confirm | Accept selected completion |
| `<C-n>` | Next item | Select next completion |
| `<C-p>` | Previous item | Select previous completion |
| `<CR>` | Abort | Close completion menu |
| `<C-Space>` | Trigger | Manually trigger completion |
| `<C-j>` | Next snippet | Jump to next snippet placeholder |
| `<C-k>` | Previous snippet | Jump to previous snippet placeholder |

---

## Configuration Structure

```
~/.config/nvim/
├── init.lua                    # Entry point, bootstraps lazy.nvim
├── ftplugin/
│   └── java.lua               # Java-specific configuration (JDTLS)
└── lua/
    ├── config/
    │   ├── autocmds.lua       # Autocommands
    │   ├── keymaps.lua        # Global keymaps
    │   ├── lsp.lua            # LSP setup and configuration
    │   ├── options.lua        # Vim options
    │   └── utils.lua          # Utility functions
    └── plugins/
        └── init.lua           # Plugin specifications (lazy.nvim)
```

---

## Installation

1. **Backup existing config** (if any):
   ```bash
   mv ~/.config/nvim ~/.config/nvim.bak
   ```

2. **Clone this repository:**
   ```bash
   git clone <your-repo-url> ~/.config/nvim
   ```

3. **Launch Neovim:**
   ```bash
   nvim
   ```
   lazy.nvim will automatically install all plugins on first launch.

4. **Install LSP servers** (optional):
   - Open Mason: `:Mason`
   - Install desired language servers

---

## Usage Tips

- Use `<leader>ff` to quickly find files by name
- Use `<leader>fg` to search for text across your project
- Use `<leader>fb` to switch between open buffers (sorted by most recently used)
- Press `<leader>` and wait to see available keybindings (which-key)
- Navigate windows with `<C-h/j/k/l>` instead of `<C-w>h/j/k/l>`
- Use `<leader>1` through `<leader>9` to jump directly to numbered buffers
- In terminal mode, press `<Esc><Esc>` to return to normal mode
- Hover over diagnostics and press `gl` to see full error messages
