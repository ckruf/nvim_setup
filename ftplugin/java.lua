-- ~/.config/nvim/ftplugin/java.lua
local jdtls = require("jdtls")
local mason = vim.fn.stdpath("data") .. "/mason"
local jdtls_path = mason .. "/packages/jdtls"
local launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")

-- Auto-detect OS for config directory
local config_dir
if vim.fn.has("mac") == 1 then
  config_dir = jdtls_path .. "/config_mac"
elseif vim.fn.has("unix") == 1 then
  config_dir = jdtls_path .. "/config_linux"
else
  config_dir = jdtls_path .. "/config_win"
end

local root_markers = { "gradlew", "mvnw", "pom.xml", "build.gradle", ".git" }
local root_dir = require("jdtls.setup").find_root(root_markers)
if root_dir == "" then return end

local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace = vim.fn.expand("~/.local/share/jdtls-workspace/") .. project_name
vim.fn.mkdir(workspace, "p")

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Setup debug bundles (java-debug-adapter and java-test)
local bundles = {}
local java_debug_path = mason .. "/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"
local java_debug_bundle = vim.fn.glob(java_debug_path, true)
if java_debug_bundle ~= "" then
  table.insert(bundles, java_debug_bundle)
end

local java_test_path = mason .. "/packages/java-test/extension/server/*.jar"
local java_test_bundles = vim.split(vim.fn.glob(java_test_path, true), "\n")
for _, bundle in ipairs(java_test_bundles) do
  if bundle ~= "" then
    table.insert(bundles, bundle)
  end
end

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
  init_options = { bundles = bundles },
}

jdtls.start_or_attach(config)

local function map(mode, lhs, rhs, desc)
  if type(rhs) == "function" then
    vim.keymap.set(mode, lhs, rhs, { buffer = true, desc = desc })
  end
end

-- Java-specific keymaps
map("n", "<leader>jo", jdtls.organize_imports, "Java: organize imports")
map("n", "<leader>jr", vim.lsp.buf.rename,     "Rename symbol")
map("n", "<leader>ca", vim.lsp.buf.code_action,"Code action")

-- Java debug keymaps
map("n", "<leader>jt", jdtls.test_nearest_method, "Java: test nearest method")
map("n", "<leader>jT", jdtls.test_class, "Java: test class")
map("n", "<leader>jm", jdtls.extract_method, "Java: extract method")
map("v", "<leader>jm", function() jdtls.extract_method(true) end, "Java: extract method")
map("n", "<leader>jv", jdtls.extract_variable, "Java: extract variable")
map("v", "<leader>jv", function() jdtls.extract_variable(true) end, "Java: extract variable")
