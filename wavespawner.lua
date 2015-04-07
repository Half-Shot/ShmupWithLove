--WaveSpawner.lua

function waveSpawnerLoad()
    wsDifficultyMod = 2
    wsShipsAlive = 0
    wsTimeBetweenWaves = 30
    wsSurvived = 0
    wsTotalSurvived = 0
    wsTotalSpawned = 0
    wsTime = wsTimeBetweenWaves
    wsMode = 'random'
    wsRNG = love.math.newRandomGenerator(os.time())
end

function loadWaveFile()

end

function countShips()
    wsShipsAlive = entityManager:CountOfType(EnemyBoat,true)
end

function WaveSpawnerUpdate(dt)
    countShips()
    if wsShipsAlive < 1 or wsTime > wsTimeBetweenWaves then
        if wsMode == 'random' then
            --Stats
            wsTotalSurvived = wsTotalSurvived + wsSurvived
            if wsTime > 0 then
                modPar = ((wsTimeBetweenWaves/2) - wsTime) / (wsTimeBetweenWaves*2)
                wsDifficultyMod = wsDifficultyMod + modPar
                survivorPeanalty = - (wsSurvived / 2)
                wsDifficultyMod = wsDifficultyMod + survivorPeanalty
                wsDifficultyMod = math.max(wsDifficultyMod,0.25)
            end
        
            wsSurvived = 0
            
            --Type
            Type = 1 --We only have one type of ship so far
            DamageOutput = wsRNG:random(1*wsDifficultyMod,5*wsDifficultyMod)
            ShipCount = wsRNG:random(2*wsDifficultyMod,3*wsDifficultyMod)
            wsTotalSpawned = wsTotalSpawned + ShipCount
            --print("Difficulty Mod is now " .. wsDifficultyMod)
            --print("Spawned new wave with " .. ShipCount .. " ships.")
            --print("\tDamageOutput:" .. DamageOutput)
            for i=1,ShipCount do
                local target = EnemyBoat:new()
                target:load()
                target.x = wsRNG:random(500,love.graphics:getWidth() - 500)
                target.y = -100
                
                if wsRNG:random(0,5) == 0 then
                    target.itemtodrop = FixPowerup
                end
                
                distanceFromPlayer = (playerboat.x - target.x)
                if distanceFromPlayer < 0 then
                    distanceFromPlayer = -distanceFromPlayer
                end
                EvadeSpeed = wsRNG:random(0*wsDifficultyMod,75*wsDifficultyMod)
                MoveSpeed = wsRNG:random(50*wsDifficultyMod,150*wsDifficultyMod) - (distanceFromPlayer / 4)
                
                target.turret.damage = DamageOutput
                target.xvel = EvadeSpeed
                target.yvel = MoveSpeed
                entityManager:Add(target)
            end
            wsTime = 0
        end
    end
    wsTime = wsTime + dt
end
