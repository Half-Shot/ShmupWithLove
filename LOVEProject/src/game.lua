--game.lua
--Core Game Code

function UpdateGame(dt,testLevel)
 pEnemyHit:update(dt)
    sReflectionLayer:send("distort",0.001)
    if testLevel ~= true then
        WaveSpawnerUpdate(dt)
    end
    updateHUD(dt)
    playerboat:update(dt)
    tileUpdate(dt)
    entityManager:Update(dt)
    for k in pairs(projectileList) do
      projectileList[k]:update(dt)
      if projectileList[k].remove then
        projectileList[k] = nil
      end
    end
    if testLevel then
        if love.keyboard.isDown( 'escape' )then
          print("Going back to editor")
          GameState:SetState(stLevelEditor)
        end
    end
end

function DrawGame()
    hudCanvas:clear()
    --Draw Water (Not dependant)
    water:clear()
    love.graphics.setCanvas(water)
    drawWater()
    love.graphics.setCanvas()
    --Draw Entites (Not Dependant)
    foreGround:clear()
    love.graphics.setCanvas(foreGround)
    tileDraw()
    entityManager:Draw()
    playerboat:draw()
    for _,k in pairs(projectileList) do
      k:draw()
    end
    love.graphics.draw(pEnemyHit,0,0)
    love.graphics.setCanvas()
    drawBlur()
    
    sShadowMap:send("ambientLight",{0.75,0.75,0.75,1})
    sShadowMap:send("light_pos",lights[1]:NormalizeXY(),lights[2]:NormalizeXY(),lights[3]:NormalizeXY(),lights[4]:NormalizeXY(),lights[5]:NormalizeXY(),lights[6]:NormalizeXY(),lights[7]:NormalizeXY(),lights[8]:NormalizeXY())
    sShadowMap:send("lights",lights[1]:NormalizeColor(),lights[2]:NormalizeColor(),lights[3]:NormalizeColor(),lights[4]:NormalizeColor(),lights[5]:NormalizeColor(),lights[6]:NormalizeColor(),lights[7]:NormalizeColor(),lights[8]:NormalizeColor())
    love.graphics.setShader(sShadowMap)
    love.graphics.draw(water)
    
    love.graphics.setShader()
    love.graphics.setBlendMode( "additive" )
    love.graphics.draw(reflectionBufferA)
    love.graphics.setBlendMode( "alpha" )
    
    love.graphics.setShader(sShadowMap)
    love.graphics.draw(foreGround)
    love.graphics.setShader()
end
