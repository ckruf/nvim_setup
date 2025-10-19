-- ~/.config/nvim/lua/config/autocmds.lua
local aug = vim.api.nvim_create_augroup
local au = vim.api.nvim_create_autocmd
local my = aug("my_autocmds", { clear = true })

-- Highlight on yank
au("TextYankPost", {
  group = my,
  callback = function() vim.highlight.on_yank({ timeout = 120 }) end,
})
