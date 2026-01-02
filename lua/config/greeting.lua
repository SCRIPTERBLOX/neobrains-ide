vim.defer_fn(function()
	-- Open nvim-tree first
	vim.cmd("NvimTreeOpen")
	
	-- Focus the main window (not nvim-tree)
	vim.cmd("wincmd l")
	
	-- Create greeting buffer with custom content from plugin config
	local greeting = require("neobrains-greeting")
	greeting.create(vim.g.neobrains_greeting_opts or {})
end, 100)
