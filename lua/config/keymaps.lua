-- Load utility functions
local utils = require("config.utils")

-- Being able to escape from Terminal mode to normal mode
vim.keymap.set('t', '<C-[>', [[<C-\><C-n>]], { desc = 'Leave terminal-mode' })

-- Diagnostics
vim.keymap.set('n', 'gl', vim.diagnostic.open_float, { desc = "Show diagnostic for current line" })
vim.keymap.set('n', 'gL', function()
  local diagnostics = vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })
  if #diagnostics == 0 then
    vim.notify("No diagnostics on this line", vim.log.levels.INFO)
    return
  end
  local messages = {}
  for _, d in ipairs(diagnostics) do
    table.insert(messages, d.message)
  end
  local text = table.concat(messages, "\n")
  vim.fn.setreg("+", text)
  vim.notify("Diagnostic copied to clipboard", vim.log.levels.INFO)
end, { desc = "Copy line diagnostic to clipboard" })

-- LSP keymaps
vim.keymap.set('n', 'grd', vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set('n', 'grD', vim.lsp.buf.declaration, { desc = "Go to declaration" })

-- File explorers
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file tree" })
vim.keymap.set("n", "<leader>o", "<cmd>Oil<CR>", { desc = "Open Oil file browser" })

-- Window navigation (easier than <C-w>h/j/k/l)
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Buffer navigation
vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bd", utils.smart_buffer_delete, { desc = "Delete buffer (smart)" })
vim.keymap.set("n", "<leader>bc", "<cmd>BufferLinePickClose<CR>", { desc = "Pick buffer to close" })
vim.keymap.set("n", "<leader>co", utils.close_other_buffers, { desc = "Close all other buffers" })

-- Jump to specific buffer by number
vim.keymap.set("n", "<leader>1", "<cmd>BufferLineGoToBuffer 1<CR>", { desc = "Go to buffer 1" })
vim.keymap.set("n", "<leader>2", "<cmd>BufferLineGoToBuffer 2<CR>", { desc = "Go to buffer 2" })
vim.keymap.set("n", "<leader>3", "<cmd>BufferLineGoToBuffer 3<CR>", { desc = "Go to buffer 3" })
vim.keymap.set("n", "<leader>4", "<cmd>BufferLineGoToBuffer 4<CR>", { desc = "Go to buffer 4" })
vim.keymap.set("n", "<leader>5", "<cmd>BufferLineGoToBuffer 5<CR>", { desc = "Go to buffer 5" })
vim.keymap.set("n", "<leader>6", "<cmd>BufferLineGoToBuffer 6<CR>", { desc = "Go to buffer 6" })
vim.keymap.set("n", "<leader>7", "<cmd>BufferLineGoToBuffer 7<CR>", { desc = "Go to buffer 7" })
vim.keymap.set("n", "<leader>8", "<cmd>BufferLineGoToBuffer 8<CR>", { desc = "Go to buffer 8" })
vim.keymap.set("n", "<leader>9", "<cmd>BufferLineGoToBuffer 9<CR>", { desc = "Go to buffer 9" })

-- Fixing shift-tab
-- Insert-mode: unindent
vim.keymap.set("i", "<S-Tab>", "<C-d>")
-- Visual-mode: keep selection and shift left
vim.keymap.set("v", "<S-Tab>", "<gv")
-- Normal-mode: shift current line left
vim.keymap.set("n", "<S-Tab>", "<<")
