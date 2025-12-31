require("config.lazy")
require("config.rebinds")

ColorMyPencils()

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
--vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup()

-- OR setup with some options
--[[require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
 })--]]

-- Open nvim-tree and create centered text
vim.cmd(":NvimTreeOpen")

-- Create centered text in main buffer
vim.defer_fn(function()
	-- Focus the main window (not nvim-tree)
	vim.cmd("wincmd l")
	
	local buf = vim.api.nvim_get_current_buf()
	
	-- Set buffer content with padding for centering
	local win_height = vim.api.nvim_win_get_height(0)
	local content_lines = {
		"Welcome to the Neobrains IDE!",
		"",
		"When focused on the file tree press Ctrl+N to add a file into the focused directory",
		"Press 'i' to enter insert mode",
		"Press ':w' to save changes of current buffer",
		"Press ':q' to quit the current buffer",
	}
	
	-- Calculate padding lines
	local padding = math.floor((win_height - #content_lines) / 2)
	local lines = {}
	
	-- Add empty lines for top padding
	for i = 1, padding do
		table.insert(lines, "")
	end
	
	-- Add content lines with horizontal centering
	local win_width = vim.api.nvim_win_get_width(0)
	for _, line in ipairs(content_lines) do
		local padding = math.floor((win_width - #line) / 2)
		local centered_line = string.rep(" ", padding) .. line
		table.insert(lines, centered_line)
	end
	
	-- Set buffer content
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	
	-- Set buffer options
	vim.api.nvim_buf_set_option(buf, "modifiable", true)
	vim.api.nvim_buf_set_option(buf, "filetype", "text")
	
	-- Focus back to nvim-tree
	vim.cmd("wincmd h")
end, 100)
