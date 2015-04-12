--Form.lua
require 'love-misoui/control'
local class = require 'middleclass/middleclass'
MUIForm = class('Form',MUIControl)

function MUIForm:initialize(parent,id)
    MUIControl.initialize(self, parent,id)
    self.children = {}
    self.type = "Form"
    self.currentFocusItem = nil
end

function MUIForm:RequestFocus(item)
    if self.currentFocusItem ~= nil then
        self.currentFocusItem.hasFocus = false
        self.currentFocusItem:defocused()
    end
    item.hasFocus = true
    item:focused()
    self.currentFocusItem = item
end

function MUIForm:Update(dt)
  for _,item in pairs(self.children) do
    if item.shouldupdate then
     item:Update(dt)
    end
  end
end

function MUIForm:Draw()
  love.graphics.setColor(self.bgColor.R,self.bgColor.G,self.bgColor.B,self.opacity)
  love.graphics.rectangle("fill",self.x,self.y,self.width,self.height)
  love.graphics.setColor(255,255,255)
  for _,item in pairs(self.children) do
    if item.shoulddraw then
     item:Draw()
    end
  end
end
