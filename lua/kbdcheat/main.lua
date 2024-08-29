local M = {}
local config = require('kbdcheat.config')

local widget_buf = nil
local widget_win = nil

local function get_window_config()
	local width = vim.api.nvim_get_option("columns")
	local height = vim.api.nvim_get_option("lines")
	local win_height = config.options.height
	local row = height - win_height - 1

	return {
		style = "minimal",
		relative = "editor",
		width = width,
		height = win_height,
		row = row,
		col = 0
	}
end

local function create_widget()
	if widget_buf and vim.api.nvim_buf_is_valid(widget_buf) then
		return
	end

	local win_opts = get_window_config()

	widget_buf = vim.api.nvim_create_buf(false, true)

	vim.api.nvim_buf_set_option(widget_buf, 'readonly', false)
	vim.api.nvim_buf_set_option(widget_buf, 'modifiable', true)
	vim.api.nvim_buf_set_lines(widget_buf, 0, -1, false, config.options.content)
	vim.api.nvim_buf_set_option(widget_buf, 'readonly', true)
	vim.api.nvim_buf_set_option(widget_buf, 'modifiable', false)

	widget_win = vim.api.nvim_open_win(widget_buf, false, win_opts)

	vim.api.nvim_win_set_option(widget_win, 'number', false)
	vim.api.nvim_win_set_option(widget_win, 'relativenumber', false)
	vim.api.nvim_win_set_option(widget_win, 'cursorline', false)
	vim.api.nvim_win_set_option(widget_win, 'winfixheight', true)
end

local function resize_widget()
	if widget_win and vim.api.nvim_win_is_valid(widget_win) then
		local win_config = get_window_config()
		vim.api.nvim_win_set_config(widget_win, win_config)
	end
end

function M.setup(opts)
	config.options = vim.tbl_deep_extend('force', config.options, opts or {})
	-- Initialize your widget here
	create_widget()

	-- Set up autocommands for resizing
	vim.api.nvim_create_autocmd("VimResized", {
		callback = resize_widget,
		group = vim.api.nvim_create_augroup("PlugWidgetResize", { clear = true }),
	})
end

-- Expose other functions if needed
M.resize_widget = resize_widget
M.create_widget = create_widget

return M
