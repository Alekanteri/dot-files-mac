local formatter = require("lvim.lsp.null-ls.formatters")
local lsp = require("lvim.lsp.manager");
local colorizer = require("colorizer")

require("tokyonight").setup({
  style = "night",
  styles = {
    comment = { italic = true }
  }
})

vim.opt.conceallevel = 1
vim.opt.wrap = true
vim.opt.relativenumber = true
vim.g.tabby_keybinding_accept = '<Tab>'

lvim.keys.insert_mode["jk"] = "<esc>"
lvim.keys.normal_mode["<leader>z"] = "<cmd>ZenMode<cr>"
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
  { "folke/zen-mode.nvim" },
  { "lunarvim/colorschemes" },
  { "folke/tokyonight.nvim" },
  { "ellisonleao/gruvbox.nvim" },
  { "sainnhe/everforest" },
  { 'TabbyML/vim-tabby' },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  },
  { "norcalli/nvim-colorizer.lua" },
  {
    "folke/todo-comments.nvim",
    event = "BufRead",
    config = function()
      require("todo-comments").setup()
    end
  },
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",

    keys = {
      { "<leader>on", "<cmd>ObsidianNew<cr>",         desc = "New Obsidian note",               mode = "n" },
      { "<leader>oo", "<cmd>ObsidianSearch<cr>",      desc = "Search Obsidian notes",           mode = "n" },
      { "<leader>os", "<cmd>ObsidianQuickSwitch<cr>", desc = "Quick Switch",                    mode = "n" },
      { "<leader>ob", "<cmd>ObsidianBacklinks<cr>",   desc = "Show location list of backlinks", mode = "n" },
      { "<leader>ot", "<cmd>ObsidianTemplate<cr>",    desc = "Follow link under cursor",        mode = "n" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
}
require("obsidian_config")
