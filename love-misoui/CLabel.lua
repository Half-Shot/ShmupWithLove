--CLabel.lua
require 'love-misoui/control'
local class = require 'middleclass/middleclass'
CLabel = class('Form',MUIControl)

function CLabel:initialize(parent,id,text,font)
    MUIControl.initialize(self, parent,id)
    self.type = "Label"
    self.text = text
    self.font = font
    self.scalex = 1
    self.fontsize = 12
    self.scaley = 1
end

function CLabel:ApplyRule(rule)
    if rule.Name == "content" then
        self.text = rule.Value
    elseif rule.Name == "font-family" then
        self.fontfamily = rule.Value
    elseif rule.Name == "font-size" then
        self.fontsize = rule.Value
    else
        CClickable.ApplyRule(self,rule)
    end
end

function CLabel:ApplyRules(ruleset)
    MUIControl.ApplyRules(self,ruleset)
    if self.font == nil then
        if self.fontfamily then
            self.font = love.graphics.newFont(self.fontfamily, self.fontsize)
        else
            self.font = love.graphics.newFont(self.fontsize)
        end
    end
end

function CLabel:Draw()
    prevFont = love.graphics.getFont()
    if self.font ~= nil then
        love.graphics.setFont(self.font)
    end
    love.graphics.print(self.text,self.x,self.y,0,self.scalex,self.scaley)
    love.graphics.setFont(prevFont)
end
