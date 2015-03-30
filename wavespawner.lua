--WaveSpawner.lua

wsDifficultyMod = 1
wsShipsAlive = 0
wsTimeBetweenWaves = 30
wsTime = 0
wsMode = 'random'
wsRNG = love.math.newRandomGenerator( )
function loadWaveFile()

end

function WaveSpawnerUpdate(dt)
    if wsShipsAlive == 0 or wsTime > wsTimeBetweenWaves then
        if wsMode == 'random' then
            wsTime = 0
            --Type
            Type = 1 --We only have one type of ship so far
            DamageOutput = wsRNG:random(1*wsDifficultyMod,5*wsDifficultyMod)
            ShipCount = wsRNG:random(2*wsDifficultyMod,3*wsDifficultyMod)
            
            wsShipsAlive = ShipCount
            for i=0,ShipCount do
                EvadeSpeed = wsRNG:random(0*wsDifficultyMod,150*wsDifficultyMod)
                MoveSpeed = wsRNG:random(50*wsDifficultyMod,300*wsDifficultyMod)
                local target = EnemyBoat:new()
                target:load()
                target.x = 80 * (i+1)
                target.y = 100
                target.turret.damage = DamageOutput
                target.xvel = EvadeSpeed
                target.yvel = MoveSpeed
                entityManager:Add(target)
            end
        end
        wsTime = wsTime + dt
    end
end
