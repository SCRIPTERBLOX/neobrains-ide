return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "NvimTree",
      callback = function()
        vim.opt_local.laststatus = 0
      end,
    })
    
    require("nvim-tree").setup {
      view = {
        width = 30,
        side = "left",
      },
      actions = {
        open_file = {
          quit_on_open = false,
          resize_window = false,
        },
      },
      renderer = {
        group_empty = true,
        indent_markers = {
          enable = true,
        },
      },
      modified = {
        enable = true,
      },
      update_focused_file = {
        enable = false,
      },
      filters = {
        dotfiles = false,
      },
    }
  end,
}
