local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end

vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			style = "night",
			styles = {
				comments = { italic = true },
			},
		},
	},
	"williamboman/mason.nvim",
	"williamboman/mason-lspconfig.nvim",
	"neovim/nvim-lspconfig",
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	{
		"stevearc/conform.nvim",
	},
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
	},
	{ "rebelot/heirline.nvim" },
	"nvim-lua/lsp-status.nvim",
	"SmiteshP/nvim-navic",
	"mfussenegger/nvim-dap",
	"SirVer/ultisnips",
	{ "akinsho/bufferline.nvim", version = "*", dependencies = "nvim-tree/nvim-web-devicons" },
	{
		"kdheepak/lazygit.nvim",
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	"mg979/vim-visual-multi",
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	},
	{
		"mfussenegger/nvim-lint",
		ft = {
			"javascript",
			"javascriptreact",
		},
		opts = {
			linters_by_ft = {
				javascript = { "eslint_d" },
				javascriptreact = { "eslint_d" },
				typescript = { "eslint_d" },
				typescriptreact = { "eslint_d" },
			},
		},
		config = function(_, opts)
			local m = require("utils.vim")

			local lint = require("lint")
			lint.linters_by_ft = opts.linters_by_ft

			m.autocmd({ "BufEnter", "BufWritePost" }, {
				group = m.augroup("Lint"),
				callback = function()
					require("lint").try_lint()
				end,
			})
		end,
	},
	"neovim/nvim-lspconfig",
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-path",
	"hrsh7th/cmp-cmdline",
	"hrsh7th/nvim-cmp",
	"hrsh7th/cmp-vsnip",
	"hrsh7th/vim-vsnip",
	"L3MON4D3/LuaSnip",
	"saadparwaiz1/cmp_luasnip",
	"SirVer/ultisnips",
	"quangnguyen30192/cmp-nvim-ultisnips",
	"dcampos/nvim-snippy",
	"dcampos/cmp-snippy",
	"nvim-treesitter/nvim-treesitter",
	"aca/emmet-ls",
	"windwp/nvim-ts-autotag",
	{ "akinsho/toggleterm.nvim", version = "*", config = true },
	{ "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
	{
		"numToStr/Comment.nvim",
		lazy = false,
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{ "hinell/duplicate.nvim" },
	{
		"mrjones2014/legendary.nvim",
		priority = 10000,
		lazy = false,
	},
	{
		"mrcjkb/rustaceanvim",
		version = "^4", -- Recommended
		ft = { "rust" },
	},
	{
		"nvimdev/lspsaga.nvim",
	},
	{ "folke/zen-mode.nvim" },
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},
	{ "norcalli/nvim-colorizer.lua" },
	{
		"epwalsh/obsidian.nvim",
		version = "*",
		lazy = true,
		ft = "markdown",

		keys = {
			{ "<leader>on", "<cmd>ObsidianNew<cr>", desc = "New Obsidian note", mode = "n" },
			{ "<leader>oo", "<cmd>ObsidianSearch<cr>", desc = "Search Obsidian notes", mode = "n" },
			{ "<leader>os", "<cmd>ObsidianQuickSwitch<cr>", desc = "Quick Switch", mode = "n" },
			{ "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Show location list of backlinks", mode = "n" },
			{ "<leader>ot", "<cmd>ObsidianTemplate<cr>", desc = "Follow link under cursor", mode = "n" },
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},
	{
		"goolord/alpha-nvim",
		config = function()
			require("alpha").setup(require("alpha.themes.dashboard").config)
		end,
	},
})

vim.cmd([[colorscheme tokyonight]])

require("default")
require("keymap")
require("mason_config")
require("lsp.lsp_config")
require("lsp.lsp_lua")
require("lsp.lsp_typescript")
require("formatter")
require("tree_config")
require("heirline_config")
require("navic_config")
require("telescope_config")
require("cmp_config")
require("treesitter_config")
require("toggleterm_config")
require("indent_config")
require("comment_config")
require("todo_config")
require("duplicate_config")
require("lsp.lsp_rust")
require("colorizer_config")
require("obsidian_config")
require("alpha_config")