-- Being able to escape from Terminal mode to normal mode
vim.keymap.set('t', '<Esc><Esc>', [[<C-\><C-n>]], { desc = 'Leave terminal-mode' })
-- Show diagnostic
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "Show diagnostic for current line" })
-- Launch Oil
vim.keymap.set("n", "<leader>o", "<cmd>Oil<CR>", { desc = "Open Oil file browser" })

-- Fixing shift-tab
-- Insert-mode: unindent
vim.keymap.set("i", "<S-Tab>", "<C-d>")
-- Visual-mode: keep selection and shift left
vim.keymap.set("v", "<S-Tab>", "<gv")
-- Normal-mode: shift current line left
vim.keymap.set("n", "<S-Tab>", "<<")
