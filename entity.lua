--ent.lua
local class = require 'middleclass/middleclass'
Entity = class('Entity')

function Entity:initialize()
  self.health = 5
  self.x = 0
  self.y = 0
  self.name = "Undefined Entity"
end

function Entity:load()
end

function Entity:update(dt)

end

function Entity:draw()

end
