local M = {}
local config = require('kbdcheat.config')

local widget_buf = nil
local widget_win = nil

local win_conf_get = function( width )
	local row = win_height - height - 1
	return function( height )
		return function( win_height )
			return {
				style = "minimal",
				relative = "editor",
				width = width,
				height = win_height,
				row = row,
				col = 0
			}
		end
	end
end

local win_setup = function( w_win )
	vim.api.nvim_win_set_option(w_win, 'number', false)
	vim.api.nvim_win_set_option(w_win, 'relativenumber', false)
	vim.api.nvim_win_set_option(w_win, 'cursorline', false)
	vim.api.nvim_win_set_option(w_win, 'winfixheight', true)
end

local widget_write = function( w_buf )
	return function( w_win )
		return function( content )
			vim.api.nvim_buf_set_option(w_buf, 'readonly', false)
			vim.api.nvim_buf_set_option(w_buf, 'modifiable', true)
			vim.api.nvim_buf_set_lines(w_buf, 0, -1, false, content)
			vim.api.nvim_buf_set_option(w_buf, 'readonly', true)
			vim.api.nvim_buf_set_option(w_buf, 'modifiable', false)
		end
	end
end

local win_redraw = function( w_win )
	return function( win_conf )
		if w_win and vim.api.nvim_win_is_valid(w_win) then
			vim.api.nvim_win_set_config(w_win, win_conf)
		end
	end
end

M.setup = function(opts)
	if widget_buf and vim.api.nvim_buf_is_valid(widget_buf) then
		return
	end

	config.options = vim.tbl_deep_extend('force', config.options, opts or {})

	widget_buf = vim.api.nvim_create_buf(false, true)
	widget_win = vim.api.nvim_open_win(widget_buf, false, win_conf)
	local	win_conf = win_conf_get( vim.api.nvim_get_option("columns") )( vim.api.nvim_get_option("lines") )( config.options.height )

	win_setup(widget_win)
	
	widget_write(widget_buf )( widget_win )( config.options.content)

	vim.api.nvim_create_autocmd("VimResized", {
		group = vim.api.nvim_create_augroup("PlugWidgetResize", { clear = true }),
		callback = function(ev)
			local	win_conf = win_conf_get( vim.api.nvim_get_option("columns") )( vim.api.nvim_get_option("lines") )( config.options.height )
			win_redraw( widget_win )( win_conf )
		end
	})
end

-- Expose other functions if needed
M.win_redraw = win_redraw
M.widget_write = widget_creat

return M
