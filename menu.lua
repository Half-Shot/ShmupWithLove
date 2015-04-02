--menu.lua

require 'love-misoui/main'

function loadMenu()
  styMenu = MUI_parseSheet("css/menu.css")
  form = MUIForm(love.graphics,"menuForm")
  logo = MUILabel(form,"versionInfo",GameVersionString,nil)
  logo.width = 100
  logo.height = 100
  table.insert(form.children,logo)
  form:ApplyStylesheet(styMenu)
end

function updateMenu(dt)
    form:Update(dt)
end

function drawMenu()
    form:Draw(dt)
end
