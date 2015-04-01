--menu.lua
function loadMenu()
  styMenu = MUI_parseSheet("css/menu.css")
  for _,item in pairs(styMenu) do
    print(item.selector)
    for _,rule in pairs(item.rules) do
        print(rule)
    end
  end
end
