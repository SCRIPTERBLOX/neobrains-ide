require("config.lazy")
require("config.rebinds")

ColorMyPencils()

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
--vim.opt.termguicolors = true

-- Setup nvim-tree with custom configuration
require("nvim-tree").setup({
  view = {
    width = 30,
    side = "left",
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = false,
  },
})

-- Create greeting in main buffer (uncloseable)
vim.defer_fn(function()
	-- Open nvim-tree first
	vim.cmd("NvimTreeOpen")
	
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
	
	-- Set buffer options to make it uncloseable but excluded from bufferline
	vim.api.nvim_buf_set_option(buf, "modifiable", true)
	vim.api.nvim_buf_set_option(buf, "filetype", "neobrains-greeting")
	vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
	vim.api.nvim_buf_set_name(buf, "Welcome")
	
	-- Make it uncloseable but only when it's the current buffer
	vim.api.nvim_create_autocmd({"BufDelete"}, {
		buffer = buf,
		callback = function()
			-- Only recreate if this was the only buffer being deleted
			-- and there are no other valid buffers to switch to
			vim.defer_fn(function()
				local valid_buffers = {}
				for _, b in ipairs(vim.api.nvim_list_bufs()) do
					if vim.api.nvim_buf_is_valid(b) and b ~= buf then
						local buftype = vim.api.nvim_buf_get_option(b, 'buftype')
						local filename = vim.api.nvim_buf_get_name(b)
						-- Only count buffers that would show in bufferline
						if buftype ~= 'nofile' and buftype ~= 'terminal' and buftype ~= 'quickfix' 
							and not filename:match("NvimTree") then
							table.insert(valid_buffers, b)
						end
					end
				end
				
				-- Only recreate greeting if there are no other valid buffers
				if #valid_buffers == 0 and not vim.api.nvim_buf_is_valid(buf) then
					local new_buf = vim.api.nvim_create_buf(false, true)
					vim.api.nvim_buf_set_option(new_buf, "filetype", "neobrains-greeting")
					vim.api.nvim_buf_set_option(new_buf, "buftype", "nofile")
					vim.api.nvim_buf_set_name(new_buf, "Welcome")
					vim.api.nvim_buf_set_lines(new_buf, 0, -1, false, lines)
					vim.api.nvim_win_set_buf(0, new_buf)
				end
			end, 10)
		end
	})
	
	-- Focus back to nvim-tree
	vim.cmd("wincmd h")
end, 100)
