--projPlayer.lua
require 'projectile'
local class = require 'middleclass/middleclass'
ProjectilePlayer = class('ProjectilePlayer',Projectile)

function ProjectilePlayer:initialize()
    self.color = Color:new(200,60,60)
end

function ProjectilePlayer:update(dt)
    Projectile.update(self,dt)
    for k,v in pairs(entityManager.entitylist) do
        if v:isInstanceOf(EnemyBoat) then
            if v.hittable then
                x1 = v.hitbox_tl.x + v.x
                x2 = v.hitbox_br.x + v.x
                y1 = v.hitbox_tl.y + v.y
                y2 = v.hitbox_br.y + v.y
                
                xfits = (self.x >= x1 and self.x <= x2)
                yfits = (self.y >= y1 and self.y <= y2)
                
                if xfits and yfits then
                    playerScore = playerScore + v.value * (self.damage / v.maxhealth)
                    self.remove = true
                    v.health = v.health - self.damage
                    if v.health <= 0 then
                        --v.deathSound:setPosition(v.x,v.y,0)
                        wsShipsAlive = wsShipsAlive - 1
                        love.audio.play(v.deathSound)
                    else
                        love.audio.play(v.hitSound)
                    end
                    
                    v.hmpos.x = self.x - x1
                    v.hmpos.y = self.y - y1
                    v.hmtime = 0
                    v.hmtext = v.hmtext + self.damage
                end
            end
        end
    end
end
