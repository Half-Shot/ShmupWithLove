--vector.lua
local class = require 'middleclass/middleclass'
Vector = class('Vector')

function Vector:initialize()
  self.x = 0
  self.y = 0
end

function Vector:initialize(a)
  self.x = a
  self.y = a
end

function Vector:initialize(x,y)
  self.x = x
  self.y = y
end

function Vector:IsZero()
    return (self.x == 0 and self.y == 0)
end
