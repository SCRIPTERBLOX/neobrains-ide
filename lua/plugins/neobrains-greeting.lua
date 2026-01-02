return {
  "SCRIPTERBLOX/neobrains-greeting.nvim",
  name = "neobrains-greeting",
  opts = {
    content = {                    -- Override default content
      "Welcome to the Neobrains IDE!",
      "",
      "When focused on the file tree press Ctrl+N to add a file into the focused directory",
      "Press 'i' to enter insert mode",
      "Press ':w' to save changes",
      "Press ':q' to quit current buffer",
      "To close the editor press Ctrl+Alt+X",
    },
    buffer_name = "Welcome",
    focus_tree_after = true,
  },
  config = function(_, opts)
    -- Store custom options in global variable for init.lua to use
    vim.g.neobrains_greeting_opts = opts
  end,
}
