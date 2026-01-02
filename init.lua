require("config.lazy")
require("config.rebinds")

ColorMyPencils()

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
--vim.opt.termguicolors = true

-- Create greeting using neobrains-greeting plugin with custom options from plugin config
vim.defer_fn(function()
	-- Open nvim-tree first
	vim.cmd("NvimTreeOpen")
	
	-- Focus the main window (not nvim-tree)
	vim.cmd("wincmd l")
	
	-- Create greeting buffer with custom content from plugin config
	local greeting = require("neobrains-greeting")
	greeting.create(vim.g.neobrains_greeting_opts or {})
end, 100)
