vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.clipboard = "unnamedplus"
-- Bootstrap lazy.nvim (plugin manager)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git","clone","--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git","--branch=stable",lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

-- Core settings
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- Plugins
require("lazy").setup("plugins")

require("config.lsp")
