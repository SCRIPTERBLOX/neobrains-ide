-- nvim-tree-file-menu plugin
return {
  "SCRIPTERBLOX/nvim-tree-file-menu",
  config = function()
    require("nvim-tree-file-menu").setup({
      add_file_key = '<C-n>',
      delete_key = '<Del>',
      ui = {
        input_width = 40,
        input_height = 1,
        input_row = 5,
        input_col = 10,
        confirm_width = 30,
        confirm_height = 4,
      },
      auto_refresh = true,
    })
  end,
  keys = {
    "<C-n>",
    "<Delete>",
  },
  dependencies = {
    "nvim-tree/nvim-tree.lua",
  },
}