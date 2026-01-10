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
        extensions = { "nvim-tree" },  -- Use dedicated extension for NvimTree statusline
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
      ensure_installed = { "lua", "vim", "vimdoc", "python", "tsx", "typescript", "javascript", "json", "yaml", "dockerfile", "bash", "markdown", "regex", "sql", "html", "css", "java", "go", "gomod", "gosum", "gowork", "c" },
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

  -- Mason DAP integration - must be top-level to ensure adapters install on startup
  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
    dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
    opts = {
      ensure_installed = { "debugpy", "delve", "js-debug-adapter", "netcoredbg", "codelldb" },
      handlers = {},
    },
  },

  -- DAP (Debug Adapter Protocol)
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- UI for debugging
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        config = function()
          local dapui = require("dapui")
          dapui.setup()

          -- Auto open/close UI when debugging starts/ends
          local dap = require("dap")
          dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
          dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
          dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
        end,
      },
      -- Virtual text showing variable values inline
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = { commented = true },
      },
    },
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "Debug: Start/Continue" },
      { "<F10>", function() require("dap").step_over() end, desc = "Debug: Step Over" },
      { "<F11>", function() require("dap").step_into() end, desc = "Debug: Step Into" },
      { "<F12>", function() require("dap").step_out() end, desc = "Debug: Step Out" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle Breakpoint" },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Debug: Conditional Breakpoint" },
      { "<leader>dl", function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end, desc = "Debug: Log Point" },
      { "<leader>dr", function() require("dap").repl.open() end, desc = "Debug: Open REPL" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Debug: Toggle UI" },
      { "<leader>de", function() require("dapui").eval() end, desc = "Debug: Evaluate", mode = { "n", "v" } },
      { "<leader>dx", function() require("dap").terminate() end, desc = "Debug: Terminate" },
    },
    config = function()
      local dap = require("dap")

      -- Python configuration
      dap.adapters.python = function(cb, config)
        if config.request == "attach" then
          local port = (config.connect or config).port
          local host = (config.connect or config).host or "127.0.0.1"
          cb({ type = "server", port = port, host = host })
        else
          local debugpy_path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
          cb({ type = "executable", command = debugpy_path, args = { "-m", "debugpy.adapter" } })
        end
      end

      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          pythonPath = function()
            -- Try to find venv python first
            local venv = os.getenv("VIRTUAL_ENV")
            if venv then return venv .. "/bin/python" end
            if vim.fn.executable("python3") == 1 then return "python3" end
            return "python"
          end,
        },
        {
          type = "python",
          request = "launch",
          name = "Launch file with arguments",
          program = "${file}",
          args = function()
            local args_string = vim.fn.input("Arguments: ")
            return vim.split(args_string, " +")
          end,
          pythonPath = function()
            local venv = os.getenv("VIRTUAL_ENV")
            if venv then return venv .. "/bin/python" end
            if vim.fn.executable("python3") == 1 then return "python3" end
            return "python"
          end,
        },
      }

      -- Go configuration (Delve)
      dap.adapters.delve = {
        type = "server",
        port = "${port}",
        executable = {
          command = vim.fn.stdpath("data") .. "/mason/bin/dlv",
          args = { "dap", "-l", "127.0.0.1:${port}" },
        },
      }

      dap.configurations.go = {
        {
          type = "delve",
          name = "Debug",
          request = "launch",
          program = "${file}",
        },
        {
          type = "delve",
          name = "Debug Package",
          request = "launch",
          program = "${fileDirname}",
        },
        {
          type = "delve",
          name = "Debug test",
          request = "launch",
          mode = "test",
          program = "${file}",
        },
        {
          type = "delve",
          name = "Debug test (go.mod)",
          request = "launch",
          mode = "test",
          program = "./${relativeFileDirname}",
        },
      }

      -- JavaScript/TypeScript configuration
      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = {
            vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
            "${port}",
          },
        },
      }

      for _, lang in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact" }) do
        dap.configurations[lang] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
        }
      end

      -- C# / .NET configuration (netcoredbg)
      dap.adapters.coreclr = {
        type = "executable",
        command = vim.fn.stdpath("data") .. "/mason/bin/netcoredbg",
        args = { "--interpreter=vscode" },
      }

      dap.configurations.cs = {
        {
          type = "coreclr",
          name = "Launch",
          request = "launch",
          program = function()
            return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
          end,
        },
        {
          type = "coreclr",
          name = "Attach",
          request = "attach",
          processId = require("dap.utils").pick_process,
        },
      }

      -- C/C++ configuration (codelldb)
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
          args = { "--port", "${port}" },
        },
      }

      dap.configurations.c = {
        {
          type = "codelldb",
          request = "launch",
          name = "Launch file",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
        {
          type = "codelldb",
          request = "launch",
          name = "Launch with arguments",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          args = function()
            local args_string = vim.fn.input("Arguments: ")
            return vim.split(args_string, " +")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }

      -- C++ uses same config as C
      dap.configurations.cpp = dap.configurations.c

      -- Breakpoint styling
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◐", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
      vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "→", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DapBreakpointRejected", linehl = "", numhl = "" })

      -- Highlight groups for breakpoints
      vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#e51400" })
      vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = "#e5a514" })
      vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#61afef" })
      vim.api.nvim_set_hl(0, "DapStopped", { fg = "#98c379", bg = "#2d3b2d" })
      vim.api.nvim_set_hl(0, "DapBreakpointRejected", { fg = "#5c6370" })
    end,
  },
}
