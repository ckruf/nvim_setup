-- Custom LSP reference counts display (like JetBrains IDEs)
-- Shows "X references" above function definitions

local M = {}

-- Configuration
M.config = {
  enable = true,
  debounce_ms = 500,
  -- Symbol kinds to show references for (from LSP spec)
  -- 12 = Function, 6 = Method, 5 = Class, 11 = Interface, 9 = Constructor
  symbol_kinds = { 5, 6, 9, 11, 12 },
  -- Highlight group for the virtual text
  hl_group = "LspCodeLens",
}

-- Namespace for extmarks
local ns = vim.api.nvim_create_namespace("lsp_references")

-- Debounce timers per buffer
local timers = {}

-- Check if a symbol kind should be tracked
local function should_track(kind)
  return vim.tbl_contains(M.config.symbol_kinds, kind)
end

-- Flatten nested symbols (LSP returns hierarchical structure)
local function flatten_symbols(symbols, result)
  result = result or {}
  for _, symbol in ipairs(symbols or {}) do
    if should_track(symbol.kind) then
      table.insert(result, symbol)
    end
    -- Recurse into children (e.g., methods inside classes)
    if symbol.children then
      flatten_symbols(symbol.children, result)
    end
  end
  return result
end

-- Get the line number for a symbol
local function get_symbol_line(symbol)
  -- Try selectionRange first (more precise), fall back to range
  local range = symbol.selectionRange or symbol.range
  if range then
    return range.start.line
  end
  return nil
end

-- Request reference count for a single symbol
local function get_references(bufnr, symbol, callback)
  local line = get_symbol_line(symbol)
  if not line then
    callback(0)
    return
  end

  local range = symbol.selectionRange or symbol.range
  local params = {
    textDocument = vim.lsp.util.make_text_document_params(bufnr),
    position = { line = line, character = range.start.character },
    context = { includeDeclaration = false },
  }

  vim.lsp.buf_request(bufnr, "textDocument/references", params, function(err, result)
    if err or not result then
      callback(0)
    else
      callback(#result)
    end
  end)
end

-- Clear all extmarks in buffer
local function clear_marks(bufnr)
  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
end

-- Set virtual text at end of line
local function set_virtual_text(bufnr, line, count)
  if count <= 0 then return end

  local text = count == 1 and "1 reference" or string.format("%d references", count)

  vim.api.nvim_buf_set_extmark(bufnr, ns, line, 0, {
    virt_text = { { text, M.config.hl_group } },
    virt_text_pos = "eol",
    hl_mode = "combine",
  })
end

-- Main update function
local function update_references(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then return end
  if not M.config.enable then return end

  -- Get attached LSP clients that support document symbols
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  local has_capable_client = false

  for _, client in ipairs(clients) do
    if client:supports_method("textDocument/documentSymbol") and
       client:supports_method("textDocument/references") then
      has_capable_client = true
      break
    end
  end

  if not has_capable_client then return end

  -- Request document symbols
  local params = { textDocument = vim.lsp.util.make_text_document_params(bufnr) }

  vim.lsp.buf_request(bufnr, "textDocument/documentSymbol", params, function(err, result)
    if err or not result then return end
    if not vim.api.nvim_buf_is_valid(bufnr) then return end

    clear_marks(bufnr)

    local symbols = flatten_symbols(result)
    if #symbols == 0 then return end

    -- Request references for each symbol
    local pending = #symbols

    for _, symbol in ipairs(symbols) do
      get_references(bufnr, symbol, function(count)
        local line = get_symbol_line(symbol)
        if line and vim.api.nvim_buf_is_valid(bufnr) then
          set_virtual_text(bufnr, line, count)
        end

        pending = pending - 1
      end)
    end
  end)
end

-- Debounced update
local function debounced_update(bufnr)
  if timers[bufnr] then
    vim.fn.timer_stop(timers[bufnr])
  end

  timers[bufnr] = vim.fn.timer_start(M.config.debounce_ms, function()
    timers[bufnr] = nil
    vim.schedule(function()
      update_references(bufnr)
    end)
  end)
end

-- Setup function
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})

  -- Create highlight group if it doesn't exist
  vim.api.nvim_set_hl(0, "LspCodeLens", { link = "Comment", default = true })

  local group = vim.api.nvim_create_augroup("LspReferences", { clear = true })

  -- Update on LSP attach
  vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
    callback = function(args)
      local bufnr = args.buf
      debounced_update(bufnr)
    end,
  })

  -- Update after saving
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = group,
    callback = function(args)
      debounced_update(args.buf)
    end,
  })

  -- Update when entering buffer
  vim.api.nvim_create_autocmd("BufEnter", {
    group = group,
    callback = function(args)
      -- Only update if LSP is attached
      if #vim.lsp.get_clients({ bufnr = args.buf }) > 0 then
        debounced_update(args.buf)
      end
    end,
  })

  -- Clear when leaving buffer (optional, saves memory)
  vim.api.nvim_create_autocmd("BufLeave", {
    group = group,
    callback = function(args)
      clear_marks(args.buf)
    end,
  })

  -- Cleanup timer on buffer delete
  vim.api.nvim_create_autocmd("BufDelete", {
    group = group,
    callback = function(args)
      if timers[args.buf] then
        vim.fn.timer_stop(timers[args.buf])
        timers[args.buf] = nil
      end
    end,
  })
end

-- Manual commands
function M.enable()
  M.config.enable = true
  local bufnr = vim.api.nvim_get_current_buf()
  update_references(bufnr)
end

function M.disable()
  M.config.enable = false
  local bufnr = vim.api.nvim_get_current_buf()
  clear_marks(bufnr)
end

function M.toggle()
  if M.config.enable then
    M.disable()
  else
    M.enable()
  end
end

function M.refresh()
  local bufnr = vim.api.nvim_get_current_buf()
  update_references(bufnr)
end

-- Create user commands
vim.api.nvim_create_user_command("LspRefEnable", M.enable, {})
vim.api.nvim_create_user_command("LspRefDisable", M.disable, {})
vim.api.nvim_create_user_command("LspRefToggle", M.toggle, {})
vim.api.nvim_create_user_command("LspRefRefresh", M.refresh, {})

return M
