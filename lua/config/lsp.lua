
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
    "jdtls",
  }
  mlsp.setup({ ensure_installed = ensure })

  -- Capabilities (nvim-cmp)
  local capabilities = require("cmp_nvim_lsp").default_capabilities()

  -- A helper to set up a server with defaults, plus per-server tweaks
  local function setup_server(name)
    if name == "jdtls" then return end

    local cfg = { capabilities = capabilities }

    if name == "lua_ls" then
      cfg.settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
        },
      }
    elseif name == "omnisharp" then
      -- OmniSharp requires explicit handlers to avoid vim.NIL errors
      cfg.handlers = {}

      -- Add omnisharp-extended handlers if available
      local ok, omnisharp_extended = pcall(require, "omnisharp_extended")
      if ok then
        cfg.handlers["textDocument/definition"] = omnisharp_extended.definition_handler
        cfg.handlers["textDocument/typeDefinition"] = omnisharp_extended.type_definition_handler
        cfg.handlers["textDocument/references"] = omnisharp_extended.references_handler
        cfg.handlers["textDocument/implementation"] = omnisharp_extended.implementation_handler
      end

      -- Add handlers for OmniSharp-specific notifications to prevent INVALID_SERVER_MESSAGE errors
      cfg.handlers["o#/msbuildprojectdiagnostics"] = function() end
      cfg.handlers["o#/backgrounddiagnosticstatus"] = function() end
      cfg.handlers["o#/projectconfiguration"] = function() end
      cfg.handlers["o#/projectdiagnosticstatus"] = function() end
      cfg.handlers["o#/unresolveddependencies"] = function() end
      cfg.handlers["o#/projectchanged"] = function() end

      cfg.on_attach = function(client, bufnr)
        -- Disable semantic tokens if they cause issues
        client.server_capabilities.semanticTokensProvider = nil
      end
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
