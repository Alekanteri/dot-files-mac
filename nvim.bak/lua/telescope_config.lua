require("telescope").setup({
  defaults = {
    file_ignore_patterns = {
      "node_modules",
      "yarn.lock"
    },
    dynamic_preview_title = true,
    path_directory = "smart"
  }
})

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
vim.keymap.set("n", "<leader>fr", builtin.oldfiles, {})
