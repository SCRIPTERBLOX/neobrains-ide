local elements = require("elements")

return {
  "SCRIPTERBLOX/neobrains-left-bar-select.nvim",
  name = "neobrains-left-bar-select",
  opts = {
    buttons = {
      top = {
        elements.Button
      }
    }
  },
  config = function(_, opts)
    -- store custom options in global variable for init.lua to use
    vim.g.neobrains_greeting_opts = opts
  end,
}
