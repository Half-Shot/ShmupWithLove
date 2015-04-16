--color.lua
local class = require 'middleclass/middleclass'
Color = class('Color')

function Color:initialize()
  self.r = 0
  self.g = 0
  self.b = 0
  self.a = 0

end

function Color:initialize(r,g,b)
  self.r = r
  self.g = g
  self.b = b
  self.a = 255
end

function Color:initialize(r,g,b,a)
  self.r = r
  self.g = g
  self.b = b
  self.a = a
end
