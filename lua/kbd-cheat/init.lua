local Buf = require("nvim-kbd-cheat.buf")
local Win = require("nvim-kbd-cheat.win")
local nvimver = "nvim-0.7.0"
local plugname = "kbd-cheat.nvim"

local M = {}

-- Define window options for split
local winOpts = {
	relative = 'editor',
	width = vim.o.columns / 2,
	height = vim.o.lines - 1,
	row = 0,
	col = vim.o.columns / 2,
	style = 'minimal',
	border = 'single',
}

-- Define content to insert into the buffer
local bufLines = {
	"Line 1",
	"Line 2",
	"Line 3"
}

function M.setup(opts)
	opts = opts or {}
	print("init setup ran")
	if vim.fn.has(nvimver) ~= 1 then
		vim.api.nvim_err_writeln(plugname .. " requires at least " .. nvimver)
	end
	local buf = Buf.create(false, true)
end

function M.execute(id)
end

function M.load()
end

function M.reset(opts)
	opts = opts or defopts
end

return M
