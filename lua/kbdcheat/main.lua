local M = {}
local config = require('kbdcheat.config')

local widget_buf = nil
local widget_win = nil

local main_win = vim.api.nvim_get_current_win()
local win_conf_get = function( win )
	return vim.api.nvim_win_get_config(win)
end

local win_conf_make = function( win_height )
	return function( root_height )
		return function( win_width )
			local row = root_height - win_height - 1
			return {
				style = "minimal",
				--relative = "editor",
				--width = win_width,
				height = win_height,
				--row = row,
				--col = 0
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
	vim.api.nvim_buf_set_option(w_buf, 'readonly', false)
	vim.api.nvim_buf_set_option(w_buf , 'modifiable', true)
	return function( w_win )
		return function( content )
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

local win_

M.setup = function(opts)
	if widget_buf and vim.api.nvim_buf_is_valid(widget_buf) then
		return
	end

	config.options = vim.tbl_deep_extend('force', config.options, opts or {})

	local win_conf_f = win_conf_make( config.options.height )
	local win_conf = win_conf_f( vim.api.nvim_get_option("lines") )( vim.api.nvim_get_option("columns") )

	widget_buf = vim.api.nvim_create_buf(false, true)
	widget_win = vim.api.nvim_open_win(widget_buf, false, win_conf)

	win_setup(widget_win)

	widget_write( widget_buf )( widget_win )( config.options.content )

	--vim.api.nvim_win_set_config(main_win, { height = win_conf_get(main_win).height - config.options.height })

	vim.api.nvim_create_autocmd("VimResized", {
		group = vim.api.nvim_create_augroup("PlugWidgetResize", { clear = true }),
		callback = function(ev)
			local win_conf = win_conf_f( vim.api.nvim_get_option("lines") )( vim.api.nvim_get_option("columns") )
			win_redraw( widget_win )( win_conf )
		end
	})
end

--M.widget_write = widget_write
--M.win_redraw = win_redraw

return M
