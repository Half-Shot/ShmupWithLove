--CClickable.lua
require 'love-misoui/control'
local class = require 'middleclass/middleclass'
CClickable = class('CClickable',MUIControl)

function CClickable:initialize(parent,id)
    MUIControl.initialize(self, parent,id)
    self.type = "Clickable"
    self.hovered = false
    self.clicked = false
    self.hoverfunction = nil
    self.clickfunction = nil
    self.pressedIn = false
    self.clickvalue = nil
    self.begunpress = false
end

function CClickable:ApplyRule(rule)
    if rule.Name == "disabled" then
        self.shouldupdate = (rule.Value ~= 1)
    else 
        MUIControl.ApplyRule(self,rule)
    end
end
function CClickable:Update(dt)
  local mousex = 0
  local mosuey = 0 
  mousex, mousey = love.mouse.getPosition( )
  self.insidex = (mousex >= self.x and mousex <= self.x + self.width) 
  self.insidey = (mousey >= self.y and mousey <= self.y + self.height)
  
  self.hovered = self.insidex and self.insidey
  
  if self.hovered and self.hoverfunction ~= nil then
    self.hoverfunction()
  end
  self.clicked = (love.mouse.isDown( 'l' ) == false) and self.pressedIn
  if self.clicked and self.clickfunction ~= nil then
    self.clickfunction(self.clickvalue)
  end
  
  self.begunpress =  love.mouse.isDown( 'l' ) and self.pressedIn == false and self.hovered
  self.pressedIn = love.mouse.isDown( 'l' ) and self.hovered
  
end
