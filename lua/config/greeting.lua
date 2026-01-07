local elements = require("elements")

vim.defer_fn(function()
  -- Open file tree
  vim.cmd("NvimTreeOpen")	
  vim.cmd("wincmd l")
	
  -- Open greeting
  local greeting = require("neobrains-greeting")
  greeting.create(vim.g.neobrains_greeting_opts or {})
	
  -- Open the left-bar
  local left_bar = require("neobrains-left-bar-select")
  local buf = left_bar.init(vim.g.neobrains_left_bar_select_opts)
  vim.cmd("wincmd l")
end, 100)
