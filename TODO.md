# TODO

## Pending

## Completed

- [x] Add LSP reference counts inline (like JetBrains IDEs)
  - Custom implementation: `lua/config/lsp-references.lua`
  - Shows "X references" at end of function/method/class definition lines
  - Works with any LSP server supporting document symbols and references
  - Commands: `:LspRefEnable`, `:LspRefDisable`, `:LspRefToggle`, `:LspRefRefresh`
