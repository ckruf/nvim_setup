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
  -- theme
  { "folke/tokyonight.nvim", lazy = false, priority = 1000, config = function() vim.cmd.colorscheme("tokyonight") end },
  -- key suggestions for nvim 
  { "folke/which-key.nvim", event = "VeryLazy", opts = {} },

  -- file browser, launch via ':Oil'
  { 
    "stevearc/oil.nvim",
    opts = {
      view_options = { show_hidden = true },
      default_file_explorer = true,
      watch_for_changes = true,
    },
  },

  -- Git 
  { "lewis6991/gitsigns.nvim", event = "BufReadPre", opts = {} },

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
        },
        pickers = {
          find_files = { theme = "dropdown" },
          live_grep  = { theme = "dropdown" },
          buffers    = { theme = "dropdown" },
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
      ensure_installed = { "lua", "vim", "vimdoc", "python", "tsx", "typescript", "javascript", "json", "yaml", "dockerfile", "bash", "markdown", "regex", "sql", "html", "css", "java" },
      highlight = { enable = true },
      indent = { enable = true },
    },
    config = function(_, opts) require("nvim-treesitter.configs").setup(opts) end
  },

  -- LSP + completion
  { "williamboman/mason.nvim", opts = {} },
  { "williamboman/mason-lspconfig.nvim" },
  { "neovim/nvim-lspconfig" },

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
