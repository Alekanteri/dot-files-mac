vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 5
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.swapfile = true
vim.opt.autoread = true
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.bo.autoread = true
vim.opt.clipboard = "unnamedplus"

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({
      higroup = "incSearch",
      timeout = 100,
    })
  end,
})
