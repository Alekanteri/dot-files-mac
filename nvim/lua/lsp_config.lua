require("lspsaga").setup({
  ui = {
    border = "rounded",
    code_action = "",
  },
})

vim.keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<cr>")
vim.keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<cr>")
vim.keymap.set("n", "<leader>lo", "<cmd>Lspsaga outline<cr>")
vim.keymap.set("n", "<leader>k", "<cmd>Lspsaga hover_doc<cr>", { silent = true })
vim.keymap.set({ 'n', 't' }, '<leader>lt', '<cmd>Lspsaga term_toggle<cr>')
vim.keymap.set('n', '<leader>lci', '<cmd>Lspsaga incoming_calls<cr>')
vim.keymap.set('n', '<leader>lco', '<cmd>Lspsaga outgoing_calls<cr>')
local builtin = require("telescope.builtin")

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gd", "<cmd>Lspsaga goto_definition<cr>", opts)
    vim.keymap.set("n", "<leader>lr", "<cmd>Lspsaga rename<cr>", opts)
    vim.keymap.set({ "n", "v" }, "<leader>la", "<cmd>Lspsaga code_action<cr>", opts)
    vim.keymap.set("n", "gr", builtin.lsp_references, opts)
  end,
})
