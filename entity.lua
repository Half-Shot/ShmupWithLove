--ent.lua
local class = require 'middleclass/middleclass'
Entity = class('Entity')

function Entity:initialize()
  self.health = 5
  self.x = 0
  self.y = 0
  self.xvel = 0
  self.yvel = 0
  self.name = "Undefined Entity"
  self.hitbox_tl = Vector:new()
  self.hitbox_br = Vector:new()
  self.remove = false
  self.hittable = true
end

function Entity:load()
end

function Entity:update(dt)

end

function Entity:draw()

end

function Entity:destroyed()

end
