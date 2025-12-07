-- ~/.config/nvim/lua/config/autocmds.lua
local aug = vim.api.nvim_create_augroup
local au = vim.api.nvim_create_autocmd
local my = aug("my_autocmds", { clear = true })

-- Highlight on yank
au("TextYankPost", {
  group = my,
  callback = function() vim.highlight.on_yank({ timeout = 120 }) end,
})

-- Auto-cd into directory when opened as argument
au("VimEnter", {
  group = my,
  callback = function()
    local dir = vim.fn.argv(0)
    if vim.fn.isdirectory(dir) == 1 then
      vim.cmd.cd(dir)
    end
  end,
})

-- LSP reference counts (shows "X references" above functions)
require("config.lsp-references").setup()
