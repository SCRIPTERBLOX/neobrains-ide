local elements = {}

elements.Spacer = {
  txt = "-",
  action = function ()
    -- Do nothing
  end
}
elements.Files = {
  txt = "󰉋",
  action = function()
  	print(123)
  end
}
elements.Git = {
  txt = "󰊢",
  action = function()
  	print(456)
  end
}

return elements
