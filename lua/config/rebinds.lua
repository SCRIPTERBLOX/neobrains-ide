local keybinds = dofile(vim.fn.stdpath('config') .. '/neobrains-config/keybinds.lua')

-- Keybindings configuration
vim.keymap.set('n', keybinds["Focus File Tree"], ':NvimTreeFocus<CR>')
vim.keymap.set('n', keybinds["Close the Editor"], function()
	vim.cmd([[:qa!]])
end)
