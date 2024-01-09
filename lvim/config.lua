local formatter = require("lvim.lsp.null-ls.formatters")
local lsp = require("lvim.lsp.manager");
local colorizer = require("colorizer")

vim.opt.wrap = true
vim.opt.relativenumber = true

lvim.keys.insert_mode["jk"] = "<esc>"
lvim.colorscheme = "tokyonight"
lvim.transparent_window = true
lvim.format_on_save = true

lsp.setup("emmet_ls")


colorizer.setup({
  "*",
}, {
  names = true,
  rgb_fn = true,
  RGB = true,
  RRGGBB = true,
  RRGGBBAA = true,
  hsl_fn = true,
  css = true,
  css_fn = true,
  mode = "background"
}
)


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
  { "norcalli/nvim-colorizer.lua" },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  }
}
