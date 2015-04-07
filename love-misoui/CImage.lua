-- CImage.lua
require 'love-misoui/control'
local class = require 'middleclass/middleclass'
CImage = class('Form',MUIControl)

function CImage:initialize(parent,id,image)
    MUIControl.initialize(self, parent,id)
    self.type = "Image"
    self.text = text
    self.image = image
end

function CImage:ApplyRules(ruleset)
    MUIControl.ApplyRules(self,ruleset)
end

function CImage:SetImage(image)
    self.image = image
    self.scalex = self.width / image:getWidth()
    self.scaley = self.height / image:getHeight()
end

function CImage:ApplyRule(rule)
    if rule.Name == "content" then
        self:SetImage(love.graphics.newImage(rule.Value)) -- Need to verify this.
    end
end

function CImage:Draw()
    love.graphics.setColor(self.bgColor.R,self.bgColor.G,self.bgColor.B)
    love.graphics.draw(self.image,self.x,self.y,0,self.scalex,self.scaley)
    love.graphics.setColor(255,255,255)
end
