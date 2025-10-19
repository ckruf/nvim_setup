
-- ~/.config/nvim/lua/config/lsp.lua

-- Prefer the new API on 0.11+, fall back to lspconfig on 0.10.x
local ok, newapi = pcall(function() return vim.lsp.config end)
local lsp = ok and newapi or require("lspconfig")

vim.defer_fn(function()
  -- Mason bootstrap
  local mason = require("mason")
  local mlsp  = require("mason-lspconfig")
  mason.setup()

  -- Servers you want installed by Mason
  local ensure = {
    -- core
    "lua_ls",
    -- python
    "pyright", -- or "basedpyright"
    -- web
    "ts_ls",   -- if this errors later, use "tsserver" on older setups
    "eslint",
    -- infra
    "dockerls", "yamlls", "jsonls",
    -- sql
    "sqls",
    -- c#
    "omnisharp",
  }
  mlsp.setup({ ensure_installed = ensure })

  -- Capabilities (nvim-cmp)
  local capabilities = require("cmp_nvim_lsp").default_capabilities()

  -- A helper to set up a server with defaults, plus per-server tweaks
  local function setup_server(name)
    local cfg = { capabilities = capabilities }

    if name == "lua_ls" then
      cfg.settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
        },
      }
    end

    -- If you're on older lspconfig, TypeScript might still be "tsserver"
    if name == "ts_ls" and not lsp.ts_ls and lsp.tsserver then
      name = "tsserver"
    end

    if lsp[name] and lsp[name].setup then
      lsp[name].setup(cfg)
    end
  end

  -- Use the list Mason reports as installed; fall back to our ensure list
  local installed = {}
  if mlsp.get_installed_servers then
    installed = mlsp.get_installed_servers()
  else
    installed = ensure
  end

  for _, server in ipairs(installed) do
    setup_server(server)
  end
end, 10)
