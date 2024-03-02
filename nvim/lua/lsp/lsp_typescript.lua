require("typescript-tools").setup({})

vim.keymap.set("n", "<leader>to", "<cmd>TSToolsOrganizeImports<cr>")
vim.keymap.set("n", "<leader>tr", "<cmd>TSToolsRemoveUnusedImports<cr>")
vim.keymap.set("n", "<leader>ta", "<cmd>TSToolsFixAll<cr>")

local api = require("typescript-tools.api")
require("typescript-tools").setup {
  handlers = {
    ["textDocument/publishDiagnostics"] = api.filter_diagnostics(
      { 6133 }
    ),
  },
}
