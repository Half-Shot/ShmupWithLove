--projEnemyBasic.lua
require 'projectile'
local class = require 'middleclass/middleclass'
ProjectileEnemyBasic = class('ProjectileEnemyBasic',Projectile)

function ProjectileEnemyBasic:initialize()
    self.color = Color:new(60,200,200)
    self.damage = 0
end

function ProjectileEnemyBasic:update(dt)
    Projectile.update(self,dt)
    for k,v in pairs(entityManager.entitylist) do
        if v:isInstanceOf(PlayerBoat) then
            x1 = v.hitbox_tl.x + v.x
            x2 = v.hitbox_br.x + v.x
            y1 = v.hitbox_tl.y + v.y
            y2 = v.hitbox_br.y + v.y
            
            xfits = (self.x >= x1 and self.x <= x2)
            yfits = (self.y >= y1 and self.y <= y2)
            
            if xfits and yfits then
                v.health = v.health - self.damage
                self.remove = true
            end
        end
    end
end
