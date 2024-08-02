local M = {}

-- Create a new buffer
function M.create(listed, scratch)
	listed = listed or false
	scratch = scratch or true
	local buf = vim.api.nvim_create_buf(listed, scratch)
	return buf
end

function M.insert(buf, lines)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
end

return M
