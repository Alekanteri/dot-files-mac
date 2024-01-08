local formatter = require("lvim.lsp.null-ls.formatters")
local lsp = require("lvim.lsp.manager");

vim.opt.wrap = true
vim.opt.relativenumber = true

lvim.keys.insert_mode["jk"] = "<esc>"
lvim.colorscheme = "tokyonight"
lvim.transparent_window = true
lvim.format_on_save = true

lsp.setup("emmet_ls")

formatter.setup {
  {
    name = "prettier",
    filetype = {
      "typescript",
      "typescriptreact",
      "javascript",
      "javascriptreact",
      "css",
      "scss",
      "rust",
      "json",
      "html",
      "markdown"
    }
  }
}

lvim.plugins = {
  { "lunarvim/colorschemes" },
  { "folke/tokyonight.nvim" },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  }
}
