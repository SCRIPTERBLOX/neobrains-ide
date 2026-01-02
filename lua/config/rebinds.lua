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
  
  -- Get current window info
  local current_win = vim.api.nvim_get_current_win()
  local win_config = vim.api.nvim_win_get_config(current_win)
  
  -- Check if this is a floating window (like Lazy UI)
  local is_floating = win_config.relative ~= ""
  
  if is_floating then
    -- For floating windows, just close them without buffer switching
    vim.cmd('close')
    return
  end
  
  -- For regular windows, find next available buffer
  local next_buf = nil
  local buffers = vim.fn.getbufinfo({buflisted = 1})
  
  for _, bufinfo in ipairs(buffers) do
    local buf = bufinfo.bufnr
    if buf ~= buf_num and vim.api.nvim_buf_is_valid(buf) then
      local buf_ft = vim.api.nvim_buf_get_option(buf, 'filetype')
      local buftype = vim.api.nvim_buf_get_option(buf, 'buftype')
      
      -- Exclude special buffers but include everything else
      if buf_ft ~= 'NvimTree' and buf_ft ~= 'neobrains-greeting' 
        and buf_ft ~= 'terminal' and buftype ~= 'quickfix' then
        next_buf = buf
        break
      end
    end
  end
  
  -- Count normal buffers (excluding special ones)
  local normal_buffer_count = 0
  for _, bufinfo in ipairs(buffers) do
    local buf = bufinfo.bufnr
    if buf ~= buf_num and vim.api.nvim_buf_is_valid(buf) then
      local buf_ft = vim.api.nvim_buf_get_option(buf, 'filetype')
      local buftype = vim.api.nvim_buf_get_option(buf, 'buftype')
      
      if buf_ft ~= 'NvimTree' and buf_ft ~= 'neobrains-greeting' 
        and buf_ft ~= 'terminal' and buftype ~= 'quickfix' then
        normal_buffer_count = normal_buffer_count + 1
      end
    end
  end
  
  -- Switch to next buffer in the current window
  if next_buf then
    vim.api.nvim_win_set_buf(current_win, next_buf)
  elseif normal_buffer_count == 0 then
    -- No other normal buffers, find and show greeting buffer
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_valid(buf) and buf ~= buf_num then
        local buf_ft = vim.api.nvim_buf_get_option(buf, 'filetype')
        if buf_ft == 'neobrains-greeting' then
          vim.api.nvim_win_set_buf(current_win, buf)
          break
        end
      end
    end
  else
    -- Create new buffer in current window
    local new_buf = vim.api.nvim_create_buf(true, false)
    vim.api.nvim_win_set_buf(current_win, new_buf)
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
