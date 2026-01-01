local keybinds = dofile(vim.fn.stdpath('config') .. '/neobrains-config/keybinds.lua')

-- Keybindings configuration
vim.keymap.set('n', keybinds["Focus File Tree"], ':NvimTreeFocus<CR>')
vim.keymap.set('n', keybinds["Close the Editor"], function()
	vim.cmd([[:qa!]])
end)

-- Buffer navigation keybindings
vim.keymap.set('n', keybinds["Buffer: Next buffer"], '<Cmd>BufferLineCycleNext<CR>')
vim.keymap.set('n', keybinds["Buffer: Previous buffer"], '<Cmd>BufferLineCyclePrev<CR>')
vim.keymap.set('n', keybinds["Buffer: Pick buffer"], '<Cmd>BufferLinePick<CR>')

-- Create smart buffer delete function
local function smart_close_buffer(buf_num)
  buf_num = buf_num or vim.api.nvim_get_current_buf()
  
  -- Don't close nvim-tree or greeting
  local ft = vim.api.nvim_buf_get_option(buf_num, 'filetype')
  if ft == 'NvimTree' or ft == 'neobrains-greeting' then
    return
  end
  
  -- Get current window (should be editing window)
  local current_win = vim.api.nvim_get_current_win()
  
  -- Find next available buffer using actual bufferline state
  local next_buf = nil
  local greeting_buf = nil
  
  -- Method 1: Try to get buffers from actual bufferline tabs
  local success, result = pcall(function()
    -- Get bufferline tabs by checking which buffers are actually shown
    local bufferline_buffers = {}
    local tabs = vim.fn.getbufinfo({buflisted = 1})
    
    for _, bufinfo in ipairs(tabs) do
      local buf = bufinfo.bufnr
      if vim.api.nvim_buf_is_valid(buf) and buf ~= buf_num then
        local buf_ft = vim.api.nvim_buf_get_option(buf, 'filetype')
        
        if buf_ft == 'neobrains-greeting' then
          greeting_buf = buf
        elseif buf_ft ~= 'NvimTree' and buf_ft ~= 'terminal' and buf_ft ~= 'quickfix' then
          -- Only include if it would actually be visible in bufferline
          local filename = vim.api.nvim_buf_get_name(buf)
          local is_listed = vim.api.nvim_buf_get_option(buf, 'buflisted')
          
          if is_listed then
            if filename ~= "" or vim.api.nvim_buf_line_count(buf) > 1 then
              table.insert(bufferline_buffers, buf)
            end
          end
        end
      end
    end
    
    return bufferline_buffers
  end)
  
  if success and #result > 0 then
    next_buf = result[1]
  else
    -- Fallback: Only use buffers that are currently loaded with content
    local buffers = vim.api.nvim_list_bufs()
    local loaded_buffers = {}
    
    for _, buf in ipairs(buffers) do
      if vim.api.nvim_buf_is_valid(buf) and buf ~= buf_num then
        local buf_ft = vim.api.nvim_buf_get_option(buf, 'filetype')
        local is_loaded = vim.api.nvim_buf_is_loaded(buf)
        
        if buf_ft == 'neobrains-greeting' and is_loaded then
          greeting_buf = buf
        elseif buf_ft ~= 'NvimTree' and buf_ft ~= 'terminal' and buf_ft ~= 'quickfix' and is_loaded then
          local filename = vim.api.nvim_buf_get_name(buf)
          local is_listed = vim.api.nvim_buf_get_option(buf, 'buflisted')
          
          if is_listed and (filename ~= "" or vim.api.nvim_buf_line_count(buf) > 1) then
            table.insert(loaded_buffers, buf)
          end
        end
      end
    end
    
    if #loaded_buffers > 0 then
      next_buf = loaded_buffers[1]
    end
  end
  
  -- CRITICAL: Switch to next buffer using vim command BEFORE closing
  if next_buf then
    vim.cmd('buffer ' .. next_buf)
  elseif greeting_buf then
    vim.cmd('buffer ' .. greeting_buf)
  else
    -- Create new buffer
    vim.cmd('enew')
  end
  
  -- Now close the original buffer
  vim.cmd('bdelete ' .. buf_num)
end

-- Create custom command for smart buffer closing
vim.api.nvim_create_user_command('SmartBdelete', function(opts)
  local buf_num = tonumber(opts.args) or vim.api.nvim_get_current_buf()
  smart_close_buffer(buf_num)
end, { nargs = '?' })

-- Override :q command using command completion
vim.api.nvim_create_user_command('Q', function()
  local ft = vim.bo.filetype
  if ft == 'NvimTree' or ft == 'neobrains-greeting' then
    return
  end
  smart_close_buffer()
end, {})

-- Create abbreviation for :q -> :Q
vim.cmd([[
  cnoreabbrev <expr> q getcmdtype() == ":" && getcmdline() == "q" ? "Q" : "q"
]])
