--hud.lua
displayedScore = 0
hitCombo = 0
function loadHUD()
	tCross = love.graphics.newImage("tCrosshair/cross.png")
	tCrossHit = love.graphics.newImage("tCrosshair/cross-hit.png")
  tCurCross = tCross
	crossScale = 0.15
  hitComboScale = 0.25
end

function drawHUD()
  --Score
  love.graphics.setFont(scoreFont)
  love.graphics.print(string.format("%08.0f",displayedScore) , love.graphics.getWidth() / 20, love.graphics.getHeight() / 20,0,0.25,0.25)
  love.graphics.print(hitCombo, love.graphics.getWidth() / 20, love.graphics.getHeight() / 15,0,hitComboScale,hitComboScale)
  love.graphics.setNewFont(12)
  
  --Hull
  
  love.graphics.setColor(0,183,14)
  love.graphics.rectangle( 'fill', (love.graphics.getWidth() / 15) , (love.graphics.getHeight() / 10) * 8.5, 200 * (playerboat.health / playerboat.maxhealth), 30 )
  love.graphics.setColor(10,10,10)
  love.graphics.rectangle( 'line', love.graphics.getWidth() / 15, (love.graphics.getHeight() / 10) * 8.5, 200, 30 )
  love.graphics.setColor(255,255,255)
  
  --Gun One
  love.graphics.setColor(150,40,40)
  love.graphics.rectangle( 'fill', (love.graphics.getWidth() / 15) , (love.graphics.getHeight() / 10) * 9, 200 * (playerboat.GunOneCooldown / playerboat.GunOneCooldownPeroid), 30 )
  love.graphics.setColor(10,10,10)
  love.graphics.rectangle( 'line', love.graphics.getWidth() / 15, (love.graphics.getHeight() / 10) * 9, 200, 30 )
  love.graphics.setColor(255,255,255)
  
  --Gun One
  love.graphics.setColor(150,40,40)
  love.graphics.rectangle( 'fill', (love.graphics.getWidth() / 15) * 5 , (love.graphics.getHeight() / 10) * 9, 200 * (playerboat.GunTwoCooldown / playerboat.GunTwoCooldownPeroid), 30 )
  love.graphics.setColor(10,10,10)
  love.graphics.rectangle( 'line', (love.graphics.getWidth() / 15) * 5, (love.graphics.getHeight() / 10) * 9, 200, 30 )
  love.graphics.setColor(255,255,255)
  
  --Cursor
  love.graphics.draw(tCurCross,mx - (tCurCross:getWidth( ) * crossScale / 2) ,my - (tCurCross:getHeight( )  * crossScale / 2),0,crossScale,crossScale)
end

function updateHUD(dt)
    mx, my = love.mouse.getPosition( )
    if playerScore > displayedScore then
        displayedScore = displayedScore + 10
    elseif playerScore < displayedScore then
        displayedScore = displayedScore - 10
    end
    if hitComboScale > 0.25 then
      hitComboScale = hitComboScale - 0.25*dt
    end
end
