require("lspsaga").setup({
	ui = {
		border = "rounded",
		code_action = "",
	},
})

vim.keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<cr>")
vim.keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<cr>")
vim.keymap.set("n", "<leader>O", "<cmd>Lspsaga outline<cr>")
vim.keymap.set("n", "<leader>k", "<cmd>Lspsaga hover_doc<cr>", { silent = true })
local builtin = require("telescope.builtin")

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		local opts = { buffer = ev.buf }
		vim.keymap.set("n", "gd", "<cmd>Lspsaga goto_definition<cr>", opts)
		vim.keymap.set("n", "<space>r", vim.lsp.buf.rename, opts)
		vim.keymap.set({ "n", "v" }, "<space>ca", "<cmd>Lspsaga code_action<cr>", opts)
		vim.keymap.set("n", "gr", builtin.lsp_references, opts)
	end,
})
