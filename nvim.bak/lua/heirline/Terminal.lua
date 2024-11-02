local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

local Align = { provider = "%=" }
local Space = { provider = " " }

local colors = require("heirline.colors")

local ViMode = require("heirline.ViMode")
local FileBlock = require("heirline.FileBlock")
local FileType = FileBlock.FileType

local TerminalName = {
	provider = function()
		local tname, _ = vim.api.nvim_buf_get_name(0):gsub(".*:", "")
		return " " .. tname
	end,
	hl = { fg = colors.blue, bold = true },
}

local TerminalStatusline = {

	condition = function()
		return conditions.buffer_matches({ buftype = { "terminal" } })
	end,

	hl = { bg = colors.dark_red },

	{ condition = conditions.is_active, ViMode, Space },
	FileType,
	Space,
	TerminalName,
	Align,
}

return TerminalStatusline
