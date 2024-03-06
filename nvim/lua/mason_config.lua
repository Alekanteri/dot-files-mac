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

require("mason-lspconfig").setup_handlers {
  function(server_name)
    require("lspconfig")[server_name].setup {}
  end,

  ["rust_analyzer"] = function()
    require("rustaceanvim").setup {}
  end,

  ["tailwindcss"] = function()
    require("lspconfig").tailwindcss.setup {}
  end,

  ["tsserver"] = function()
    require("typescript-tools").setup({})

    vim.keymap.set("n", "<leader>to", "<cmd>TSToolsOrganizeImports<cr>")
    vim.keymap.set("n", "<leader>tr", "<cmd>TSToolsRemoveUnusedImports<cr>")
    vim.keymap.set("n", "<leader>ta", "<cmd>TSToolsFixAll<cr>")

    local api = require("typescript-tools.api")
    require("typescript-tools").setup {
      handlers = {
        ["textDocument/publishDiagnostics"] = api.filter_diagnostics(
          { 6133 }
        ),
      },
    }
  end,

  ["html"] = function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    require 'lspconfig'.html.setup {
      capabilities = capabilities,
    }
  end,

  ["emmet_ls"] = function()
    require 'lspconfig'.emmet_ls.setup {}
  end,

  ["cssls"] = function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    require 'lspconfig'.cssls.setup {
      capabilities = capabilities,
    }
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
}
