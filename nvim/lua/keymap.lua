local kmap = vim.keymap

vim.g.mapleader = " "

kmap.set("n", "<leader>q", "<cmd>q<cr>")
kmap.set("n", "<leader>w", "<cmd>w<cr>")

kmap.set("i", "jk", "<esc>")
kmap.set("n", "<leader>h", "<cmd>noh<cr>")
kmap.set("n", "<leader>gg", "<cmd>lazyGit<cr>")
