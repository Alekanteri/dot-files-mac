vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true

require("nvim-tree").setup({
	sort = {
		sorter = "case_sensitive",
	},
	view = {
		width = 35,
	},
	renderer = {
		group_empty = true,
		icons = {
			glyphs = {
				git = {
					unstaged = "",
					staged = "S",
					unmerged = "",
					renamed = "",
					untracked = "U",
					deleted = "",
					ignored = "◌",
				},
			},
		},
	},
	git = {
		enable = true,
		ignore = false,
		show_on_dirs = true,
		show_on_open_dirs = true,
	},
	filters = {
		dotfiles = false,
	},
	diagnostics = {
		enable = true,
		show_on_dirs = true,
		icons = {
			hint = "",
			info = "",
			warning = "",
			error = "",
		},
	},
})

vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<cr>")
vim.keymap.set("n", "<C-h>", "<C-w>w")
