--light.lua
local class = require 'middleclass/middleclass'
Light = class('Light')

function Light:initialize(r,g,b,intensity)
    self.R = r
    self.G = g
    self.B = b
    self.A = intensity
    self.x = 0
    self.y = 0
end

function Light:NormalizeColor()
    return {self.R/255,self.G/255,self.B/255,self.A/255}
end

function Light:NormalizeXY()
    return {self.x / love.graphics.getWidth(), self.y / love.graphics.getHeight()}
end

