local conditions = require("heirline.conditions")

local colors = require("heirline.colors")

local LSPActive = {
  condition = conditions.lsp_attached,
  update = { "LspAttach", "LspDetach" },
  provider = function()
    local names = {}
    for i, server in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
      table.insert(names, server.name)
    end
    return " [" .. table.concat(names, " ") .. "]"
  end,
  hl = { fg = colors.green, bold = true },
}

local LSPMessages = {
  provider = require("lsp-status").status(),
  hl = { fg = colors.gray },
}

local DAPMessages = {
  condition = function()
    local session = require("dap").session()
    return session ~= nil
  end,
  provider = function()
    return " " .. require("dap").status()
  end,
  hl = "Debug",
}

return {
  LSPActive = LSPActive,
  LSPMessages = LSPMessages,
  DAPMessages = DAPMessages
}
