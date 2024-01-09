-- Create a new buffer
local buf = vim.api.nvim_create_buf(false, true)

-- Define window options for split
local window_options = {
    relative = 'editor',
    width = vim.o.columns / 2,
    height = vim.o.lines - 1,
    row = 0,
    col = vim.o.columns / 2,
    style = 'minimal',
    border = 'single',
}

-- Open the buffer in a new split window
vim.api.nvim_open_win(buf, true, window_options)

-- Set the buffer to read-only
vim.api.nvim_buf_set_option(buf, 'readonly', true)

-- Optionally, insert content into the buffer
local lines = {"Line 1", "Line 2", "Line 3"}
vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

