## Introduction

Hello everyone, my dear programmers, today we will step by step make from the standard vim, a full-fledged tool capable of replacing VSCode if desired.

I often hear this question from my friends. Why not use a ready-made config like _LazyVim_ or _NVChad_? Well, firstly, I am the kind of person who likes to have control over all aspects of what I use. Secondly, when you say that you made your own config from scratch - it sounds cooler than just installing a couple of plugins (─‿‿─).

Can this replace _VSCode_? Maybe, as for me Vim is more convenient and faster to use than VSCode, but then again sometimes I also use _VSCode_, for some specific cases.

If you have any questions about the code, you can use [my repository](https://github.com/Alekanteri/dot-files-mac) as a reference.

## Configuration

First, you need to prepare your working environment (terminal) for correct work with vim. Preparation consists in the fact that you need to install fonts for displaying icons. Using [Nerd Fonts](https://www.nerdfonts.com/#home) download the fonts that you like best, but I recommend _JetBrainsMono_, I tried _Hack_, but it did not have all the icons, which is why I did not use it. Set the font in your terminal settings.

Next, install [NeoVim](https://neovim.io/) itself on your device via the official website, or if you have _homebrew_, you can install it via the appropriate command `brew install neovim`, _Linux_ users have their own package managers for installing packages, but I will not list them :)

And now we go to _.config_ directory and create here the new _nvim_ folder, this is where we will write all our code.

### Basic setup

And finally we can start writing the configuration, create the `init.lua` file in the _nvim_ folder. For convenience, we will split our config into different modules, but ultimately all modules will be imported into the `init.lua` file. For example, let's create a new file `default.lua`, in order for lua to recognize this file as a module we must create it in a folder called _lua_, otherwise it will not be visible to the main file when imported.
```
├── init.lua
└── lua
   └── default.lua
```
In this file we will write some basic commands:

```lua
--default.lua

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
```
To import this file we write this in init.lua:

```lua
--init.lua

require("default")

-- in the future I will not show that I import this or that file into init.lua, just know that if I write that a new file is created, then in most cases it will be imported into init.lua
```

Ok, let's go back to our `init.lua`, and install our first plugin, or rather the _lazy.nvim_ plugin manager, through it we will install all our plugins in the future.

{% embed https://github.com/folke/lazy.nvim %}


to install it you need to write the following piece of code:

```lua
--init.lua

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
```
For further installation of plugins, we add a structure from the plugin manager and inside it we will add new plugins:

```lua
--init.lua

require("lazy").setup({})
```

For example, let's set a color scheme, I like [TokyoNight](https://github.com/folke/tokyonight.nvim), you can set any you like:

```lua
--init.lua

require("lazy").setup({
---
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
---
})

-- to apply the color scheme we write this
vim.cmd([[colorscheme tokyonight]])
```

Restart our _nvim_ and all done! <(￣︶￣)>

In _neovim_ you can set your own keymap, create a new file `keymap.lua`,  my standard layout looks like this:

```lua
--keymap.lua

local kmap = vim.keymap

vim.g.mapleader = " "

kmap.set("n", "<leader>q", "<cmd>q<cr>")
kmap.set("n", "<leader>w", "<cmd>w<cr>")

kmap.set("i", "jk", "<esc>")
kmap.set("n", "<leader>h", "<cmd>noh<cr>")
```

The next step is to install and configure the _Mason_ package manager, it  allows you to easily manage external editor tooling such as LSP servers, DAP servers, linters, and formatters through a single interface.

{% embed https://github.com/williamboman/mason.nvim %}

first of all, let's install it:

```lua
--init.lua

  require("lazy").setup({
---
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  { "neovim/nvim-lspconfig" },
  { "WhoIsSethDaniel/mason-tool-installer.nvim" },
---
  })
```

Restart our `nvim` and it should install normally. Now let's write the configuration of the package manager itself. Create a new file `mason_config.lua` and here we write this:

```lua
---mason_config.lua

require("mason").setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})
require("mason-lspconfig").setup()
```

Okay, now let's set up our first language server, here you choose for which language you need to install a server, for example, I need servers for _html_, _css_, _typescript_, _rust_, _tailwind_ and _lua_, in addition I will install _emmet_ for faster work with html.

How do you find the configuration for your language? This package manager has a [List with all supported language servers](https://github.com/williamboman/mason-lspconfig.nvim/blob/main/doc/server-mapping.md), look for the language you need there, in nvim through the command `:Mason` look for the package name as in the table, and install, then in the next column open the link to the language server, and take the configuration from there. Let's install the language server for all languages that i use as an example

> For language servers sometimes you need to install additional plugins, for example, for _rust_ you need to install _rustaceanvim_, or for _TS_ - _typescript-tools_, and additionally a linter, so if you need to work with these languages, here are these plugins, for other languages ​​look in the repository link to which is above

```lua
--init.lua

  require("lazy").setup({
---
   {
    "mrcjkb/rustaceanvim",
    version = "^4", -- Recommended
    ft = { "rust" },
  },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  },
  {
    "mfussenegger/nvim-lint",
    linters_by_ft = {
      javascript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescript = { "eslint_d" },
      typescriptreact = { "eslint_d" },
    },
  },
---
  })
```

```lua
---mason_config.lua

---

require("mason-lspconfig").setup_handlers({
  function(server_name)
    require("lspconfig")[server_name].setup({})
  end,

  ["rust_analyzer"] = function()
    require("rustaceanvim").setup({})
  end,

  ["tailwindcss"] = function()
    require("lspconfig").tailwindcss.setup({})
  end,

  ["tsserver"] = function()
    require("typescript-tools").setup({})

    vim.keymap.set("n", "<leader>to", "<cmd>TSToolsOrganizeImports<cr>")
    vim.keymap.set("n", "<leader>tr", "<cmd>TSToolsRemoveUnusedImports<cr>")
    vim.keymap.set("n", "<leader>ta", "<cmd>TSToolsFixAll<cr>")

    local api = require("typescript-tools.api")
    require("typescript-tools").setup({
      handlers = {
        ["textDocument/publishDiagnostics"] = api.filter_diagnostics({ 6133 }),
      },
    })
  end,

  ["html"] = function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    require("lspconfig").html.setup({
      capabilities = capabilities,
    })
  end,

  ["emmet_ls"] = function()
    require("lspconfig").emmet_ls.setup({})
  end,

  ["cssls"] = function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    require("lspconfig").cssls.setup({
      capabilities = capabilities,
    })
  end,

  ["lua_ls"] = function()
    require("lspconfig").lua_ls.setup({
      on_init = function(client)
        local path = client.workspace_folders[1].name
        if not vim.loop.fs_stat(path .. "/.luarc.json") and not vim.loop.fs_stat(path .. "/.luarc.jsonc") then
          client.config.settings = vim.tbl_deep_extend("force", client.config.settings, {
            Lua = {
              diagnostics = {
                globals = { "vim" },
              },
              runtime = {
                version = "LuaJIT",
              },
              workspace = {
                checkThirdParty = false,
                library = {
                  vim.env.VIMRUNTIME,
                },
              },
            },
          })
        end
        return true
      end,
    })
  end,
})
```

The first language server is ready, congratulations. Let's now add formatting to our code so that it looks more structured. To do this, install it via _lazy.nvim_ and immediately write its config in a separate file `formatter.lua`

```lua
--init.lua

require("lazy").setup({
---

  {"stevearc/conform.nvim",},

---

})
```

Now we write its configuration, for this we need to install the corresponding formatters via _Mason_, for example _prettier_ for _JS/TS_ or _stylua_ for _lua_. Some language servers have ready-made formatters, for example _rust_analyzer_, so there is no need to configure code formatting for them. In our case, we need to install _stylua_ for lua, which is what we are doing.

```lua
--formatter.lua

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
	},
	format_on_save = {
		timeout_ms = 500,
		lsp_fallback = true,
	},
})
```

Lastly for this chapter, let's set up autopairs so that when you type an opening parenthesis, a closing parenthesis is automatically created.

```lua
--init.lua

require("lazy").setup({
---

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },

---

})
```

There is no need to configure anything here, everything works out of the box.

### Let's make it better

We are done with the basic settings, now let's move on to improving our working environment. We will add convenient file navigation, a search engine and much more.

let's start with the explorer, everything is pretty standard here, we install the required plugin and write its configuration in a separate file.

{% embed https://github.com/nvim-tree/nvim-tree.lua %}

Adding a plugin to `init.lua`

```lua
--init.lua


require("lazy").setup({
---

  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

---

})
```

Create a new file `tree_config.lua` and write all of this:

```lua
--tree_config.lua

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

--Open Expkorer
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<cr>")
--Change focus from code to Explorer
vim.keymap.set("n", "<C-h>", "<C-w>w")
```

Now let's add a plugin for quick search of files or text in files, for this you need to install _telescope.nvim_. Everything is as always, we install via `init.lua` and create a new file.

{% embed https://github.com/nvim-telescope/telescope.nvim %}

```lua
--init.lua

require("lazy").setup({
---

  {
    "nvim-telescope/telescope.nvim",
    --The version is entered manually, so it may differ from the latest, so enter the version from the repository
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
---

})
```

And now let's set up our plugin a little. Create a file `telescope_config.lua`

```lua
---telescope_config.lua

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
```

Now let's add auto-completion to our config. For this we will use _nvim-cmp_ install it in the way we are already familiar with.

{% embed https://github.com/hrsh7th/nvim-cmp %}

```lua
--init.lua

require("lazy").setup({
---

  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "hrsh7th/cmp-cmdline" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-vsnip" },
  { "hrsh7th/vim-vsnip" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },
---

})
```

Create a new file `cmp_config.lua`

```lua
--cmp_config.lua

local cmp = require('cmp')

local kind_icons = {
  Text = "",
  Method = "󰆧",
  Function = "󰊕",
  Constructor = "",
  Field = "󰇽",
  Variable = "󰂡",
  Class = "󰠱",
  Interface = "",
  Module = "",
  Property = "󰜢",
  Unit = "",
  Value = "󰎠",
  Enum = "",
  Keyword = "󰌋",
  Snippet = "",
  Color = "󰏘",
  File = "󰈙",
  Reference = "",
  Folder = "󰉋",
  EnumMember = "",
  Constant = "󰏿",
  Struct = "",
  Event = "",
  Operator = "󰆕",
  TypeParameter = "󰅲",
}


cmp.setup({
  formatting = {
    format = function(entry, vim_item)
      vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
      vim_item.menu = ({
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        luasnip = "[LuaSnip]",
        nvim_lua = "[Lua]",
        latex_symbols = "[LaTeX]",
      })[entry.source.name]
      return vim_item
    end
  },
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
  })
})

cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'git' },
  }, {
    { name = 'buffer' },
  })
})

cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})
```

Well, let's quickly write a config for treesitter. _Nvim-treesitter_ is based on three interlocking features: language parsers, queries, and modules, where modules provide features – e.g., highlighting.

{% embed https://github.com/nvim-treesitter/nvim-treesitter %}

To install, add it to `lazy.nvim`

```lua

require("lazy").setup({
---

  { "nvim-treesitter/nvim-treesitter" },

---

})
```

And as always, we write the configuration in a separate file:

```lua
--treesitter_config.lua

require 'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { "lua", "vim", "vimdoc", "query", "javascript", "typescript", "html", "css", "rust", "markdown", "json" },

  sync_install = false,
  auto_install = true,

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  autotag = {
    enable = true,
  }
}

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false
```

There is a small plugin that allows you to link brackets by color, let's add it.

```lua

require("lazy").setup({
---

  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },

---

})
```

Create a new file `indent_config.lua`:
> If you don't like the colorful theme, you can make the configuration more down to earth, but I like when the brackets are different colors.

```lua
--indent_config.lua

local highlight = {
  "RainbowRed",
  "RainbowYellow",
  "RainbowBlue",
  "RainbowOrange",
  "RainbowGreen",
  "RainbowViolet",
  "RainbowCyan",
}

local hooks = require "ibl.hooks"
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
  vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
  vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
  vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
  vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
  vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
  vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
  vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
end)

require("ibl").setup { indent = { highlight = highlight } }
```

Let's add two small plugins to improve your comments in code right away. The first plugin allows you to quickly comment one or more lines with one key. The second plugin allows you to expand comments, leaving notes like in a to-do list.

```lua
--init.lua

require("lazy").setup({
---

  {
    "numToStr/Comment.nvim",
    lazy = false,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

---

})
```

And configure each of them in their own file, although for the comment switcher this is not really necessary, you can just call it in our `init.lua` file, but I'd rather separate it into a separate file.

```lua
--comment_config.lua

require('Comment').setup()
```

```lua
--todo_config.lua

require("todo-comments").setup({
  signs = true,      
  sign_priority = 8, 
  
  keywords = {
    FIX = {
      icon = " ", 
      color = "error", 
      alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, 
    },
    TODO = { icon = " ", color = "info" },
    HACK = { icon = " ", color = "warning" },
    WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
    PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
    NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
    TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
  },
  gui_style = {
    fg = "NONE",         
    bg = "BOLD",         
  },
  merge_keywords = true,
  highlight = {
    multiline = true,                
    multiline_pattern = "^.",        
    multiline_context = 10,          
    before = "",                     
    keyword = "wide",
    after = "fg",                    
    pattern = [[.*<(KEYWORDS)\s*:]], 
    comments_only = true,            
    max_line_len = 400,              
    exclude = {},                    
  },
  colors = {
    error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
    warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
    info = { "DiagnosticInfo", "#2563EB" },
    hint = { "DiagnosticHint", "#10B981" },
    default = { "Identifier", "#7C3AED" },
    test = { "Identifier", "#FF00FF" }
  },
  search = {
    command = "rg",
    args = {
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
    },
    -- regex that will be used to match keywords.
    -- don't replace the (KEYWORDS) placeholder
    pattern = [[\b(KEYWORDS):]], -- ripgrep regex
    -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
  },
})

vim.keymap.set("n", "]t", function()
  require("todo-comments").jump_next()
end, { desc = "Next todo comment" })

vim.keymap.set("n", "[t", function()
  require("todo-comments").jump_prev()
end, { desc = "Previous todo comment" })

--to search by comments
vim.keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>")
```

for css I use _colorizer_ to immediately see what color palette I applied to a given class, installation and configuration is simple

```lua
--init.lua

require("lazy").setup({
---

  { "norcalli/nvim-colorizer.lua" },

---

})
```

```lua
--conlorizer_config.lua

require("colorizer").setup({
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
	mode = "background",
})
```

Now our vim looks much better, but it's not over yet, there's the last section left, in it we will integrate separate cli inside our vim, further improve the UI and add many new features

### God mode activation

Ok, here is the last section, let's summarize what we will do here. First, we will add a start page, just for beauty; if you use _Obsidian_, then it can be integrated into _vim_, this is also on our plan today; we will add a preview of `.md` files; cli for working with _git_; a very large and cool plugin for improving the UI, which combines a buffer, an integrated terminal, navigation tips, git integration and much more; and most importantly - where would we be without AI in 2024 (⌒ω⌒)

Let's start with something simpler, preview of md files, we will not configure it, as for me it is more convenient to launch it through the vim command, but if you want you can configure it for yourself.

```lua
--init.lua

require("lazy").setup({
---

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },

---

})

```

Let's now create a start page, you can add an image in ASCII format to it, google the image to your taste, but for example I will choose this:

```lua
--init.lua

require("lazy").setup({
---

    {
    "goolord/alpha-nvim",
    config = function()
      require("alpha").setup(require("alpha.themes.dashboard").config)
    end,
    },

---

})
```

```lua
--alpha_config.lua

local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

dashboard.section.header.val = {
	"⠄⠄⠄⢰⣧⣼⣯⠄⣸⣠⣶⣶⣦⣾⠄⠄⠄⠄⡀⠄⢀⣿⣿⠄⠄⠄⢸⡇⠄⠄",
	"⠄⠄⠄⣾⣿⠿⠿⠶⠿⢿⣿⣿⣿⣿⣦⣤⣄⢀⡅⢠⣾⣛⡉⠄⠄⠄⠸⢀⣿⠄",
	"⠄⠄⢀⡋⣡⣴⣶⣶⡀⠄⠄⠙⢿⣿⣿⣿⣿⣿⣴⣿⣿⣿⢃⣤⣄⣀⣥⣿⣿⠄",
	"⠄⠄⢸⣇⠻⣿⣿⣿⣧⣀⢀⣠⡌⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠿⠿⣿⣿⣿⠄",
	"⠄⢀⢸⣿⣷⣤⣤⣤⣬⣙⣛⢿⣿⣿⣿⣿⣿⣿⡿⣿⣿⡍⠄⠄⢀⣤⣄⠉⠋⣰",
	"⠄⣼⣖⣿⣿⣿⣿⣿⣿⣿⣿⣿⢿⣿⣿⣿⣿⣿⢇⣿⣿⡷⠶⠶⢿⣿⣿⠇⢀⣤",
	"⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣽⣿⣿⣿⡇⣿⣿⣿⣿⣿⣿⣷⣶⣥⣴⣿⡗",
	"⢀⠈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠄",
	"⢸⣿⣦⣌⣛⣻⣿⣿⣧⠙⠛⠛⡭⠅⠒⠦⠭⣭⡻⣿⣿⣿⣿⣿⣿⣿⣿⡿⠃⠄",
	"⠘⣿⣿⣿⣿⣿⣿⣿⣿⡆⠄⠄⠄⠄⠄⠄⠄⠄⠹⠈⢋⣽⣿⣿⣿⣿⣵⣾⠃⠄",
	"⠄⠘⣿⣿⣿⣿⣿⣿⣿⣿⠄⣴⣿⣶⣄⠄⣴⣶⠄⢀⣾⣿⣿⣿⣿⣿⣿⠃⠄⠄",
	"⠄⠄⠈⠻⣿⣿⣿⣿⣿⣿⡄⢻⣿⣿⣿⠄⣿⣿⡀⣾⣿⣿⣿⣿⣛⠛⠁⠄⠄⠄",
	"⠄⠄⠄⠄⠈⠛⢿⣿⣿⣿⠁⠞⢿⣿⣿⡄⢿⣿⡇⣸⣿⣿⠿⠛⠁⠄⠄⠄⠄⠄",
	"⠄⠄⠄⠄⠄⠄⠄⠉⠻⣿⣿⣾⣦⡙⠻⣷⣾⣿⠃⠿⠋⠁⠄⠄⠄⠄⠄⢀⣠⣴",
	"⣿⣿⣿⣶⣶⣮⣥⣒⠲⢮⣝⡿⣿⣿⡆⣿⡿⠃⠄⠄⠄⠄⠄⠄⠄⣠⣴⣿⣿⣿",
}

dashboard.section.buttons.val = {
	dashboard.button("<leader> ft", "T  > Find Text", "<CMD> Telescope live_grep<CR>"),
	dashboard.button("<leader> ff", "  > Find File", "<CMD>Telescope find_files<CR>"),
	dashboard.button("<Leader> fr", "  > Recent", ":Telescope oldfiles<CR>"),
	dashboard.button("<leader>  q", "  > Quit NVIM", ":qa<CR>"),
}

alpha.setup(dashboard.opts)

vim.cmd([[
    autocmd FileType alpha setlocal nofoldenable
]])
```

...I'm a terrible person, I know 	(￣□￣」)

I love _Obsidian_, it's a very handy management and note taking app, so to have quick access to it I decided to add it here.

```lua
--init.lua

require("lazy").setup({
---

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

---

})
```

> I will warn you in advance that you need to manually specify the path to the folder with all your files, I will highlight this line in the code, in it just write the path to your _Obsidian_ folder.

```lua
--obsidian_config.lua

require("obsidian").setup({
  workspaces = {
    {
      --Specify the name that is convenient for you, and be sure to specify the path to your folder
      name = "Name",
      path = "Path",
    },
  },
  completion = {
    nvim_cmp = true,
    min_chars = 2,
  },
  new_notes_location = "current_dir",
  wiki_link_func = function(opts)
    if opts.id == nil then
      return string.format("[[%s]]", opts.label)
    elseif opts.label ~= opts.id then
      return string.format("[[%s|%s]]", opts.id, opts.label)
    else
      return string.format("[[%s]]", opts.id)
    end
  end,

  mappings = {
    -- "Obsidian follow"
    ["<leader>of"] = {
      action = function()
        return require("obsidian").util.gf_passthrough()
      end,
      opts = { noremap = false, expr = true, buffer = true },
    },
    -- Toggle check-boxes "obsidian done"
    ["<leader>od"] = {
      action = function()
        return require("obsidian").util.toggle_checkbox()
      end,
      opts = { buffer = true },
    },
    -- Create a new newsletter issue
    ["<leader>onn"] = {
      action = function()
        return require("obsidian").commands.new_note("Newsletter-Issue")
      end,
      opts = { buffer = true },
    },
    ["<leader>ont"] = {
      action = function()
        return require("obsidian").util.insert_template("Newsletter-Issue")
      end,
      opts = { buffer = true },
    },
  },

  note_frontmatter_func = function(note)
    local out = { Title = "None", Complete = false, tags = note.tags }

    if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
      for k, v in pairs(note.metadata) do
        out[k] = v
      end
    end
    return out
  end,

  note_id_func = function(title)
    local suffix = ""
    if title ~= nil then
      suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
    else
      for _ = 1, 4 do
        suffix = suffix .. string.char(math.random(65, 90))
      end
    end
    return tostring(os.time()) .. "-" .. suffix
  end,

  templates = {
    subdir = "Templates",
    date_format = "%Y-%m-%d-%a",
    time_format = "%H:%M",
    tags = "",
  },
})

vim.opt.conceallevel = 1
```

The next step is to add one very powerful tool that will improve your vim experience.

```lua
--init.lua

require("lazy").setup({
---

  {"nvimdev/lspsaga.nvim"},

---

})
```

And let's set it up accordingly.

```lua
--lsp_config.lua

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
--this terminal is from the next plugin, it just won't work!!!
vim.keymap.set({ 'n', 't' }, [[<c-\>]], '<cmd>Lspsaga term_toggle<cr>')
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
```

Now I want to clarify the situation a little, the next plugin has quite a large code, so I will not write it here, otherwise half of this article will be only for it. Therefore, I came to a consensus, I will just leave a link to this plugin and recommend that you figure it out yourself, it is not difficult, you just copy and paste the code from their manual to yourself. You can also configure it at your own discretion. I will only say that it has a buffer zone, you can improve the explorer we already have, install a git observer and many other informative things.

{% embed https://github.com/rebelot/heirline.nvim %}

As a result, you should get something like this, when I was setting it up, I broke everything down into separate components, just to make it more convenient:

!!!!

Let's integrate lazygit into our config, it provides a git interface to visualize your project. But first you need to install it on your device.

{% embed https://github.com/jesseduffield/lazygit#installation %}

After installation, install the plugin:

```lua
--init.lua

require("lazy").setup({
---

  { 'kdheepak/lazygit.nvim' },

---

})
```

for quick access you can set keymap:

```lua
--keymap.lua

---
kmap.set("n", "<leader>gg", "<cmd>lazyGit<cr>")
```

The penultimate plugin will be the simplest, it will simply prompt you for key combinations, the combinations that you have written down yourself are duplicated here.


```lua
--init.lua

require("lazy").setup({
---

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
  },

---

})
```

The configuration is appropriate:

```lua
--whichkey_config.lua

require("which-key").setup({
  plugins = {
    marks = true,    -- shows a list of your marks on ' and `
    registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    spelling = {
      enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      suggestions = 20, -- how many suggestions should be shown in the list?
    },
    presets = {
      operators = true, -- adds help for operators like d, y, ...
      motions = true,   -- adds help for motions
      text_objects = true, -- help for text objects triggered after entering an operator
      windows = true,   -- default bindings on <c-w>
      nav = true,       -- misc bindings to work with windows
      z = true,         -- bindings for folds, spelling and others prefixed with z
      g = true,         -- bindings for prefixed with g
    },
  },
  operators = { gc = "Comments" },
  motions = {
    count = true,
  },
  icons = {
    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
    separator = "➜", -- symbol used between a key and it's label
    group = "+", -- symbol prepended to a group
  },
  popup_mappings = {
    scroll_down = "<c-d>", -- binding to scroll down inside the popup
    scroll_up = "<c-u>", -- binding to scroll up inside the popup
  },
  window = {
    border = "single",      -- none, single, double, shadow
    position = "bottom",    -- bottom, top
    margin = { 2, 1, 2, 1 }, -- extra window margin [top, right, bottom, left]. When between 0 and 1, will be treated as a percentage of the screen size.
    padding = { 1, 2, 1, 2 }, -- extra window padding [top, right, bottom, left]
    winblend = 50,          -- value between 0-100 0 for fully opaque and 100 for fully transparent
    zindex = 1000,          -- positive value to position WhichKey above other floating windows.
  },
  layout = {
    height = { min = 4, max = 25 },                                                -- min and max height of the columns
    width = { min = 20, max = 50 },                                                -- min and max width of the columns
    spacing = 3,                                                                   -- spacing between columns
    align = "center",                                                              -- align columns left, center or right
  },
  ignore_missing = false,                                                          -- enable this to hide mappings for which you didn't specify a label
  hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "^:", "^ ", "^call ", "^lua " }, -- hide mapping boilerplate
  show_help = true,                                                                -- show a help message in the command line for using WhichKey
  show_keys = true,                                                                -- show the currently pressed key and its label as a message in the command line
  triggers = "auto",                                                               -- automatically setup triggers
  triggers_nowait = {
    "`",
    "'",
    "g`",
    "g'",
    '"',
    "<c-r>",
    "z=",
  },
  triggers_blacklist = {
    i = { "j", "k" },
    v = { "j", "k" },
  },
  disable = {
    buftypes = {},
    filetypes = {},
  },
})

require("which-key").register({
  f = {
    name = "File",
    f = { "<cmd>Telescope find_files<cr>", "Find File" },
    t = { "<cmd>Telescope live_grep<cr>", "Find Text" },
    r = { "<cmd>Telescope oldfiles<cr>", "Old Files" },
    b = { "<cmd>Telescope buffers<cr>", "Find Buffer" },
    h = { "<cmd>Telescope help_tags<cr>", "Open Help Page" },
  },
  b = {
    name = "Buffers",
    c = { "<cmd>bd<cr>", "Close Current Buffer" },
  },
  g = {
    name = "Git",
    g = { "<cmd>LazyGit<cr>", "LazyGit" },
  },
  t = {
    name = "TypeScript Tools",
  },
  e = { "Sidebar" },
  q = { "Quit" },
  w = { "Save" },
  h = { "No highlight" },
  k = { "LSP Saga Documentation" },
  o = {
    name = "Obsidian Tools",
  },
  l = {
    name = "LSPsaga",
    o = "LSP Outline",
    r = "LSP Rename",
    t = "Open Terminal",
    a = "Code Action",
    c = {
      name = "Call Hierachy",
      i = "Inconming Calls",
      o = "Outgoing Calss",
    },
  },
}, { prefix = "<leader>" })
```
Well, the last thing I would like to do is to run our vim through neovide, but this is optional. First, you need to download it from the [official site](https://neovide.dev/), then write a small config for it in init.lua and everything is ready:

```lua
--init.lua

if vim.g.neovide then
  --if you want transparency, add it
  vim.g.neovide_transparency = 0.9
  --Write your font and its size
  vim.opt.guifont = { "JetBrainsMono Nerd Font", ":h12" }
  --Fill in the remaining fields at your discretion, whatever you like best
end
```

And finally the final boss, it is not as difficult as all before, although I would even say that there is nothing to do here. And so, installing the AI, first download the AI ​​model itself, look at how to install it on your device on the official website, in my case it is `brew install tabbyml/tabby/tabby`
Next install the plugin in _vim_:

{% embed https://tabby.tabbyml.com/ %}


```lua
--init.lua

require("lazy").setup({
---

  { "TabbyML/vim-tabby" },

---

})
```

Launch our server through this command and everything is ready:
`tabby serve --device metal --model StarCoder-1B`

Here we come to the end, in the end I will say that it turned out quite interesting, the config turned out not ideal, because there is always something that can be improved or improved. I wrote all this for the first time, I just wanted to try, and therefore criticism is welcome <(￣︶￣)>

All the best to you, dear programmers.
