local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

local Align = { provider = "%=" }
local Space = { provider = " " }

local colors = require("heirline.colors")
local ViMode = require("heirline.ViMode")

local FileBlock = require("heirline.FileBlock")
local FileNameBlock, FileType, FileName, HelpFileName =
    FileBlock.FileNameBlock, FileBlock.FileType, FileBlock.FileName, FileBlock.HelpFileName

local TerminalStatusline = require("heirline.Terminal")

local Git = require("heirline.git")

local Lsp = require("heirline.Lsp")
local LSPActive, LSPMessages, DAPMessages = Lsp.LSPActive, Lsp.LSPMessages, Lsp.DAPMessages

local Tabline = require("heirline.Tabline")
local TabLineOffset, BufferLine, TabPages, TablinePicker =
    Tabline.TabLineOffset, Tabline.BufferLine, Tabline.TabPages, Tabline.TablinePicker

local Navic = require("heirline.navic")

local Ruler = {
  provider = "%7(%l/%3L%):%2c %P",
}

local ScrollBar = {
  static = {
    sbar = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" },
  },
  provider = function(self)
    local curr_line = vim.api.nvim_win_get_cursor(0)[1]
    local lines = vim.api.nvim_buf_line_count(0)
    local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
    return string.rep(self.sbar[i], 2)
  end,
  hl = { fg = colors.blue, bg = colors.bright_bg },
}

local Snippets = {
  condition = function()
    return vim.tbl_contains({ "s", "i" }, vim.fn.mode())
  end,
  provider = function()
    local forward = (vim.fn["UltiSnips#CanJumpForwards"]() == 1) and "" or ""
    local backward = (vim.fn["UltiSnips#CanJumpBackwards"]() == 1) and " " or ""
    return backward .. forward
  end,
  hl = { fg = "red", bold = true },
}

ViMode = utils.surround({ "", "" }, colors.bright_bg, { ViMode, Snippets })

local DefaultStatusline = {
  ViMode,
  Space,
  Git,
  Align,
  LSPActive,
  Space,
  LSPMessages,
  Space,
  FileType,
  Space,
  Ruler,
  Space,
  ScrollBar,
}

local InactiveStatusline = {
  condition = conditions.is_not_active,
  FileType,
  Space,
  FileName,
  Align,
}

local SpecialStatusline = {
  condition = function()
    return conditions.buffer_matches({
      buftype = { "nofile", "prompt", "help", "quickfix" },
      filetype = { "^git.*", "fugitive" },
    })
  end,

  FileType,
  Space,
  HelpFileName,
  Align,
}

local StatusLines = {

  hl = function()
    if conditions.is_active() then
      return "StatusLine"
    else
      return "StatusLineNC"
    end
  end,

  fallthrough = false,

  SpecialStatusline,
  TerminalStatusline,
  InactiveStatusline,
  DefaultStatusline,
}

local WinBar = {
  FileNameBlock,
  Space,
  Navic,
  DAPMessages,
  Align,
}

local TabLine = { TabLineOffset, BufferLine, TabPages, TablinePicker }

require("heirline").setup({
  statusline = StatusLines,
  winbar = WinBar,
  tabline = TabLine,

  opts = {
    disable_winbar_cb = function(args)
      return conditions.buffer_matches({
        buftype = { "nofile", "prompt", "help", "quickfix" },
        filetype = { "^git.*", "fugitive", "Trouble", "dashboard" },
      }, args.buf)
    end,
  },
})

vim.o.showtabline = 2
vim.cmd([[au FileType * if index(['wipe', 'delete'], &bufhidden) >= 0 | set nobuflisted | endif]])
