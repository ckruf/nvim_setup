-- Utility functions for Neovim config

local M = {}

-- Smart buffer delete: switches to another buffer before deleting to prevent window issues
function M.smart_buffer_delete()
  local current_buf = vim.api.nvim_get_current_buf()
  local buftype = vim.bo[current_buf].buftype

  -- Don't try to delete special buffers (terminal, nvim-tree, etc.)
  if buftype ~= "" then
    vim.cmd("close")
    return
  end

  -- Get list of normal buffers (not special ones)
  local buffers = vim.tbl_filter(function(buf)
    return vim.api.nvim_buf_is_valid(buf)
      and vim.bo[buf].buflisted
      and vim.bo[buf].buftype == ""
      and buf ~= current_buf
  end, vim.api.nvim_list_bufs())

  -- If there are other buffers, switch to one before deleting
  if #buffers > 0 then
    -- Try to switch to the previous buffer first
    local ok = pcall(vim.cmd, "bprevious")
    if not ok then
      -- If that fails, try next
      pcall(vim.cmd, "bnext")
    end
  end

  -- Now delete the original buffer
  vim.cmd("bdelete " .. current_buf)
end

return M
