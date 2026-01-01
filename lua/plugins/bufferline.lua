return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    require("bufferline").setup({
      options = {
        numbers = "ordinal", -- buffer numbers
        close_command = "SmartBdelete %d", -- close buffer using smart function
        right_mouse_command = "SmartBdelete %d",
        diagnostics = "nvim_lsp",
        show_buffer_close_icons = true,
        show_close_icon = true,
        separator_style = "slant",
        -- Exclude nvim-tree and special buffers from bufferline
        custom_filter = function(buf_number)
          -- Filter out nvim-tree and other special buffers
          local buftype = vim.api.nvim_buf_get_option(buf_number, 'buftype')
          local filename = vim.api.nvim_buf_get_name(buf_number)
          local filetype = vim.api.nvim_buf_get_option(buf_number, 'filetype')
          
          -- Exclude nvim-tree by filename
          if filename:match("NvimTree") then
            return false
          end
          
          -- Exclude greeting buffer (named with a special filetype)
          if filetype == "neobrains-greeting" then
            return false
          end
          
          -- Exclude empty unnamed buffers (the default Neovim startup buffer)
          if filename == "" and vim.api.nvim_buf_line_count(buf_number) <= 1 then
            local first_line = vim.api.nvim_buf_get_lines(buf_number, 0, 1, false)[1] or ""
            if first_line == "" then
              return false
            end
          end
          
          -- Exclude other special buffer types
          if buftype == 'terminal' or buftype == 'quickfix' then
            return false
          end
          
          return true
        end,
        -- Configure bufferline to only span the main editing area
        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer",
            highlight = "Directory",
            separator = true,
            text_align = "left"
          }
        },
      }
    })
    
    -- Set up bufferline with proper positioning
    vim.opt.showtabline = 2
  end
}
