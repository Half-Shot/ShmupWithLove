--CLabel.lua
require 'love-misoui/control'
local class = require 'middleclass/middleclass'
MUILabel = class('Form',MUIControl)

function MUILabel:initialize(parent,id,text,font)
    MUIControl.initialize(self, parent,id)
    self.type = "Label"
    self.text = text
    self.font = font
    self.scalex = 1
    self.scaley = 1
    if self.font == nil then
        self.font = love.graphics.newFont(12)
    end
end

function MUILabel:ApplyRule(rule)
    if rule.Name == "content" then
        self.text = rule.Value
    end
end

function MUILabel:Draw()
    prevFont = love.graphics.getFont()
    if self.font ~= nil then
        love.graphics.setFont(self.font)
    end
    love.graphics.print(self.text,self.x,self.y,0,self.scalex,self.scaley)
    love.graphics.setFont(prevFont)
end
