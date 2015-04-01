--WaveSpawner.lua

wsDifficultyMod = 1
wsShipsAlive = 0
wsTimeBetweenWaves = 30
wsSurvived = 0
wsTotalSurvived = 0
wsTime = wsTimeBetweenWaves
wsMode = 'random'
wsRNG = love.math.newRandomGenerator( )
function loadWaveFile()

end

function WaveSpawnerUpdate(dt)
    if wsShipsAlive < 1 or wsTime > wsTimeBetweenWaves then
        if wsMode == 'random' then
            --Stats
            print("Survivors " .. wsSurvived)
            wsTotalSurvived = wsTotalSurvived + wsSurvived
            print("Total " .. wsTotalSurvived)
            print("Took " ..wsTime.." seconds.")
            if wsTime > 0 then
                modPar = ((wsTimeBetweenWaves/2) - wsTime) / (wsTimeBetweenWaves*2)
                print("Time Diff Bonus " .. modPar)
                wsDifficultyMod = wsDifficultyMod + modPar
                survivorPeanalty = - (wsSurvived / 2)
                print("Survivor Peanalty: ".. survivorPeanalty)
                wsDifficultyMod = wsDifficultyMod + survivorPeanalty
                wsDifficultyMod = math.max(wsDifficultyMod,0.25)
            end
        
            wsSurvived = 0
            
            --Type
            Type = 1 --We only have one type of ship so far
            DamageOutput = wsRNG:random(1*wsDifficultyMod,5*wsDifficultyMod)
            ShipCount = wsRNG:random(2*wsDifficultyMod,3*wsDifficultyMod)
            wsShipsAlive = ShipCount + wsShipsAlive
            print("Difficulty Mod is now " .. wsDifficultyMod)
            print("Spawned new wave with " .. ShipCount .. " ships.")
            print("\tDamageOutput:" .. DamageOutput)
            for i=1,ShipCount do
                EvadeSpeed = wsRNG:random(0*wsDifficultyMod,75*wsDifficultyMod)
                MoveSpeed = wsRNG:random(50*wsDifficultyMod,150*wsDifficultyMod)
                local target = EnemyBoat:new()
                target:load()
                target.x = 80 * (i+1)
                target.y = 100
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
