--projPlayer.lua
require 'projectile'
local class = require 'middleclass/middleclass'
ProjectilePlayer = class('ProjectilePlayer',Projectile)

function ProjectilePlayer:initialize()
    self.color = Color:new(200,60,60)
    self.penetrating = false
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
                    if self.penetrating == false then
                        self.remove = true
                    end
                    if v.health > 0 then
                        hitCombo = hitCombo + 1
                        v.hmpos.x = self.x - x1
                        v.hmpos.y = self.y - y1
                        pEnemyHit:setPosition( self.x, self.y )
                        pEnemyHit:emit(self.damage)
                        v.hmtime = 0
                        v.hmtext = v.hmtext + self.damage
                        v.health = v.health - self.damage
                        if v.health <= 0 then
                            --v.deathSound:setPosition(v.x,v.y,0)
                            love.audio.play(v.deathSound)
                            if v.itemtodrop ~= nil then
                              local itemtodrop = v.itemtodrop:new()
                              itemtodrop.target = playerboat
                              itemtodrop.x = v.x
                              itemtodrop.y = v.y
                              itemtodrop:load()
                              entityManager:Add(itemtodrop)
                            end
                        else
                            love.audio.play(v.hitSound)
                            playerScore = playerScore + v.value * (self.damage / v.maxhealth) * (hitCombo / 10)
                            hitComboScale = 0.75
                        end
                    end
                end
            end
        end
    end
end

ProjectileMissilePlayer = class('ProjectileMissilePlayer',ProjectilePlayer)
function ProjectileMissilePlayer:draw()
  love.graphics.draw(tProjMissilePlayer,self.x,self.y,self.rot,0.02,0.02)
end
