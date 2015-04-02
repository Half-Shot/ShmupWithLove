--CLabel.lua
require 'love-misoui/control'
local class = require 'middleclass/middleclass'
MUILabel = class('Form',MUIControl)

function MUILabel:initialize(parent,id,text,font)
    MUIControl.initialize(self, parent,id)
    self.children = {}
    self.type = "label"
    self.text = text
    self.font = font
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
    love.graphics.print(self.text,self.x,self.y)
    love.graphics.setFont(prevFont)
end
