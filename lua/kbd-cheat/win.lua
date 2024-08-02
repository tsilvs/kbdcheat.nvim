local M = {}

function M.open(buf, enter, opts)
	buf = buf or 0
	enter = enter or false
	opts = opts or {}
	-- Open the buffer in a new split window
	-- Open a horizontal split
	vim.cmd('split')
	-- Get the handle of the new window
	local new_win = vim.api.nvim_get_current_win()
	-- Move to the new split window
	vim.cmd('winc k')
	-- Get the handle of the original window
	local original_win = vim.api.nvim_get_current_win()
	-- Resize the new window
	vim.api.nvim_win_set_height(new_win, 20)
	-- Set content
	
	-- Set the buffer to read-only
	vim.api.nvim_buf_set_option(buf, 'readonly', true)
	
	return new_win
end

return M
