local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

local colors = require("heirline.colors")

local Space = { provider = " " }

local FileNameBlock = {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
  end,
}

local FileIcon = {
  init = function(self)
    local filename = self.filename
    local extension = vim.fn.fnamemodify(filename, ":e")
    self.icon, self.icon_color =
        require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
  end,
  provider = function(self)
    return self.icon and (self.icon .. " ")
  end,
  hl = function(self)
    return { fg = self.icon_color }
  end,
}

local FileName = {
  provider = function(self)
    local filename = vim.fn.fnamemodify(self.filename, ":.")
    if filename == "" then
      return "[No Name]"
    end
    if not conditions.width_percent_below(#filename, 0.25) then
      filename = vim.fn.pathshorten(filename)
    end
    return filename
  end,
  hl = { fg = utils.get_highlight("Directory").fg },
}

local FileFlags = {
  {
    condition = function()
      return vim.bo.modified
    end,
    provider = "[+]",
    hl = { fg = colors.green },
  },
  {
    condition = function()
      return not vim.bo.modifiable or vim.bo.readonly
    end,
    provider = "",
    hl = { fg = colors.orange },
  },
}

local HelpFileName = {
  condition = function()
    return vim.bo.filetype == "help"
  end,
  provider = function()
    local filename = vim.api.nvim_buf_get_name(0)
    return vim.fn.fnamemodify(filename, ":t")
  end,
  hl = { fg = colors.blue },
}

local FileNameModifer = {
  hl = function()
    if vim.bo.modified then
      return { fg = colors.cyan, bold = true, force = true }
    end
  end,
}

local FileType = {
  provider = function()
    return string.lower(vim.bo.filetype)
  end,
  hl = { fg = utils.get_highlight("Type").fg, bold = true },
}

FileNameBlock = utils.insert(
  FileNameBlock,
  FileIcon,
  utils.insert(FileNameModifer, FileName),
  Space,
  FileFlags,
  { provider = "%<" }
)

return {
  FileIcon = FileIcon,
  FileFlags = FileFlags,
  FileNameModifer = FileNameModifer,
  FileType = FileType,
  FileName = FileName,
  FileNameBlock = FileNameBlock,
  HelpFileName = HelpFileName,
}
