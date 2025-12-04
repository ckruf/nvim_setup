return {
  -- Core libs
  { "nvim-lua/plenary.nvim", lazy = true },

  -- UI / UX
  -- status bar
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({
        options = {
          theme = "tokyonight",             -- Match your colorscheme
          icons_enabled = true,
          section_separators = "",          -- Disable powerline-style symbols
          component_separators = "│",       -- Simple vertical bar
          disabled_filetypes = { "NvimTree", "oil" }, -- Don’t show in sidebars
        },
        sections = {
          lualine_a = { "mode" },                           -- NORMAL / INSERT / etc.
          lualine_b = { "branch" },                         -- Git branch
          lualine_c = { { "filename", path = 1 } },         -- Show relative path
          lualine_x = {
            { "diagnostics", sources = { "nvim_diagnostic" } }, -- LSP diagnostics
            "encoding",
            "fileformat",
            "filetype",
          },
          lualine_y = { "progress" },                       -- % through file
          lualine_z = { "location" },                       -- line:col
        },
        inactive_sections = {                               -- Simpler when window unfocused
          lualine_a = {},
          lualine_b = {},
          lualine_c = { { "filename", path = 1 } },
          lualine_x = {},
          lualine_y = {},
          lualine_z = { "location" },
        },
      })
    end,
  },

  -- Buffer tabs
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",
          themable = true,
          numbers = "ordinal",  -- Show 1, 2, 3... for easy jumping
          close_command = "bdelete! %d",
          right_mouse_command = "bdelete! %d",
          left_mouse_command = "buffer %d",
          middle_mouse_command = nil,
          indicator = {
            style = "underline",
          },
          buffer_close_icon = "×",
          modified_icon = "●",
          close_icon = "",
          left_trunc_marker = "",
          right_trunc_marker = "",
          diagnostics = false,  -- Disabled to keep tabs clean
          -- Filter out special buffers
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              text_align = "center",
              separator = true,
            },
          },
          -- Exclude nvim-tree and terminal buffers from showing as tabs
          custom_filter = function(buf_number)
            local buftype = vim.bo[buf_number].buftype
            local filetype = vim.bo[buf_number].filetype
            -- Filter out special buffer types
            if buftype == "terminal" then return false end
            if filetype == "NvimTree" then return false end
            return true
          end,
          show_buffer_close_icons = true,
          show_close_icon = false,
          show_tab_indicators = true,
          separator_style = "thin",
          always_show_bufferline = true,
          sort_by = "id",  -- Keep buffers in order by ID, so numbers stay consistent
        },
      })
    end,
  },

  -- theme
  { "folke/tokyonight.nvim", lazy = false, priority = 1000, config = function() vim.cmd.colorscheme("tokyonight") end },
  -- key suggestions for nvim 
  { "folke/which-key.nvim", event = "VeryLazy", opts = {} },

  -- file browser, launch via ':Oil'
  {
    "stevearc/oil.nvim",
    opts = {
      view_options = { show_hidden = true },
      default_file_explorer = false,  -- nvim-tree is now default
      watch_for_changes = true,
    },
  },

  -- File tree sidebar
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- Disable netrw for nvim-tree
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      require("nvim-tree").setup({
        -- Automatically open when nvim starts on a directory
        hijack_directories = {
          enable = true,
          auto_open = true,
        },
        -- Replace netrw
        disable_netrw = true,
        hijack_netrw = true,
        -- Update working directory when changing dirs in tree
        update_cwd = true,
        sync_root_with_cwd = true,
        -- Don't show nvim-tree in buffer list
        view = {
          side = "left",
          width = 35,
          number = true,
          relativenumber = true,
        },
        -- Hide nvim-tree buffer from buffer lists
        filters = {
          dotfiles = false,
          custom = {},
        },
        -- Git integration
        git = {
          enable = true,
          ignore = false,
        },
        -- Show hidden files
        renderer = {
          hidden_display = "all",
          icons = {
            show = {
              git = true,
              folder = true,
              file = true,
              folder_arrow = true,
            },
          },
        },
        -- File management actions
        actions = {
          open_file = {
            quit_on_open = false,  -- Keep tree open when opening file
            window_picker = {
              enable = true,
            },
          },
        },
      })
    end,
  },

  -- Commenting
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    opts = {
      -- LHS of toggle mappings in NORMAL mode
      toggler = {
        line = 'gcc',  -- Line-comment toggle keymap
        block = 'gbc', -- Block-comment toggle keymap
      },
      -- LHS of operator-pending mappings in NORMAL and VISUAL mode
      opleader = {
        line = 'gc',   -- Line-comment keymap
        block = 'gb',  -- Block-comment keymap
      },
    },
  },

  -- Git
  { "lewis6991/gitsigns.nvim", event = "BufReadPre", opts = {} },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Git diff" },
      { "<leader>gs", "<cmd>DiffviewOpen --staged<cr>", desc = "Git diff staged" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File history" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Branch history" },
      { "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Close diffview" },
    },
    opts = {},
  },

  -- Fuzzy find
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- faster fuzzy searching
    },
    keys = {
      { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find files" },
      { "<leader>fg", function() require("telescope.builtin").live_grep() end,  desc = "Grep text"  },
      { "<leader>fb", function() require("telescope.builtin").buffers() end,    desc = "Find buffers" },
      { "<leader>fh", function() require("telescope.builtin").help_tags() end,  desc = "Help tags" },
    },
    config = function()
      local telescope = require("telescope")

      telescope.setup({
        defaults = {
          path_display = { "smart" },
          layout_config = {
            horizontal = { preview_width = 0.55 },
            vertical = { mirror = false },
          },
          sorting_strategy = "ascending",
          layout_strategy = "horizontal",
          winblend = 5,                    -- small transparency
          file_ignore_patterns = {
            "node_modules/",
            "venv/",
            ".venv/",
            "env/",
            ".git/",
            "%.pyc$",
            "__pycache__/",
            "%.class$",
            "target/",
            "build/",
            "dist/",
            "%.o$",
            "%.a$",
            "%.out$",
            "%.pdf$",
            "%.zip$",
            "%.tar%.gz$",
          },
        },
        pickers = {
          find_files = { theme = "dropdown" },
          live_grep  = { theme = "dropdown" },
          buffers    = {
            theme = "dropdown",
            sort_mru = true,
            ignore_current_buffer = true,
            initial_mode = "normal",
            mappings = {
              i = { ["<C-d>"] = "delete_buffer" }, -- delete in insert mode
              n = { ["d"] = "delete_buffer" },     -- delete in normal mode
            },
          },
          help_tags  = { theme = "dropdown" },
        },
        extensions = {
          fzf = {
            fuzzy = true,                  -- true: fuzzy; false: exact
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      })

      telescope.load_extension("fzf")      -- enable fzf extension
    end,
  },

  -- Terminal
  { 
    "akinsho/toggleterm.nvim", 
    version = "*", 
    opts = {
      size = function (term)
        if term.direction == "horizontal" then
          return 20
        elseif term.direction == "vertical" then
          return 60
        end
      end,
      open_mapping = [[<C-\>]],
      shade_terminals = true,
      direction = "vertical",  -- could also be "horizontal" or "float"
      start_in_insert = true,
      persist_size = true,
    },
  },


  { "mfussenegger/nvim-jdtls", ft = "java" },

  -- Treesitter (syntax/AST)
  { "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = { "lua", "vim", "vimdoc", "python", "tsx", "typescript", "javascript", "json", "yaml", "dockerfile", "bash", "markdown", "regex", "sql", "html", "css", "java", "go", "gomod", "gosum", "gowork" },
      highlight = { enable = true },
      indent = { enable = true },
    },
    config = function(_, opts) require("nvim-treesitter.configs").setup(opts) end
  },

  -- LSP + completion
  { "williamboman/mason.nvim", opts = {} },
  { "williamboman/mason-lspconfig.nvim" },
  { "neovim/nvim-lspconfig" },

  -- C# / .NET LSP
  {
    "seblyng/roslyn.nvim",
    ft = "cs",
    opts = {
      -- Roslyn configuration
      filewatching = "auto",
      broad_search = false,
      lock_target = false,
      silent = false,
    },
  },

  { "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        completion = { completeopt = "menu,menuone,noinsert,noselect" },
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping.confirm({ select = true }),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<CR>"] = function(fallback)
            if cmp.visible() then cmp.abort() end
            fallback()
          end,
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-j>"] = function(fallback)
            if luasnip.expand_or_jumpable() then luasnip.expand_or_jump() else fallback() end
          end,
          ["<C-k>"] = function(fallback)
            if luasnip.jumpable(-1) then luasnip.jump(-1) else fallback() end
          end,
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },  -- snippet *suggestions* in the menu
          { name = "buffer" },
          { name = "path" },
        },
      })
    end
  },
}
