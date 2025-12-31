local keybinds = dofile(vim.fn.stdpath('config') .. '/neobrains-config/keybinds.lua')

local cmp = require "cmp"

-- Create CMP mappings lookup table
local cmp_mappings = {
  ["Autocomplete: Select next item"] = cmp.mapping.select_next_item(),
  ["Autocomplete: Select previous item"] = cmp.mapping.select_prev_item(),
  ["Autocomplete: Scroll docs up"] = cmp.mapping.scroll_docs(-4),
  ["Autocomplete: Scroll docs down"] = cmp.mapping.scroll_docs(4),
  ["Autocomplete: Complete"] = cmp.mapping.complete(),
  ["Autocomplete: Close"] = cmp.mapping.close(),
  ["Autocomplete: Confirm selection"] = cmp.mapping.confirm {
    behavior = cmp.ConfirmBehavior.Insert,
    select = true,
  },
  ["Autocomplete: Tab: next item or expand snippet"] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_next_item()
    elseif require("luasnip").expand_or_jumpable() then
      require("luasnip").expand_or_jump()
    else
      fallback()
    end
  end, { "i", "s" }),
  ["Autocomplete: Shift-Tab: previous item or jump in snippet"] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_prev_item()
    elseif require("luasnip").jumpable(-1) then
      require("luasnip").jump(-1)
    else
      fallback()
    end
  end, { "i", "s" }),
}

-- Build mapping table from keybinds.lua
local mapping = {}
for description, key in pairs(keybinds) do
  if cmp_mappings[description] then
    mapping[key] = cmp_mappings[description]
  end
end

local options = {
  completion = { completeopt = "menu,menuone" },

  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },

  mapping = mapping,

  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "nvim_lua" },
    { name = "async_path" },
  },
}

return options
--return vim.tbl_deep_extend("force", options, require "nvchad.cmp")
