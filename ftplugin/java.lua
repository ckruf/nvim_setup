-- ~/.config/nvim/ftplugin/java.lua
local jdtls = require("jdtls")
local mason = vim.fn.stdpath("data") .. "/mason"
local jdtls_path = mason .. "/packages/jdtls"
local launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
local config_dir = jdtls_path .. "/config_mac"  -- macOS. On Linux: config_linux

local root_markers = { "gradlew", "mvnw", "pom.xml", "build.gradle", ".git" }
local root_dir = require("jdtls.setup").find_root(root_markers)
if root_dir == "" then return end

local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace = vim.fn.expand("~/.local/share/jdtls-workspace/") .. project_name
vim.fn.mkdir(workspace, "p")

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local config = {
  cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xms1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    "-jar", launcher,
    "-configuration", config_dir,
    "-data", workspace,
  },
  root_dir = root_dir,
  capabilities = capabilities,
  settings = {
    java = {
      eclipse = { downloadSources = true },
      maven = { downloadSources = true },
      configuration = { updateBuildConfiguration = "interactive" },
      signatureHelp = { enabled = true },
      references = { includeDecompiledSources = true },
    },
  },
  init_options = { bundles = {} },
}

jdtls.start_or_attach(config)

-- start_or_attach(config) ... then:
local function map(mode, lhs, rhs, desc)
  if type(rhs) == "function" then
    vim.keymap.set(mode, lhs, rhs, { buffer = true, desc = desc })
  end
end

local jdtls = require("jdtls")

-- always available
map("n", "<leader>jo", jdtls.organize_imports, "Java: organize imports")
map("n", "<leader>jr", vim.lsp.buf.rename,     "Rename symbol")
map("n", "<leader>ca", vim.lsp.buf.code_action,"Code action")
