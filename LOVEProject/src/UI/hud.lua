--hud.lua
displayedScore = 0
hitCombo = 0
shouldDrawFPS = true
bestHitCombo = 0
function loadHUD()
  hudStyle = MUI_parseSheet("css/hud.css")
  if hudForm == nil then
    tCross = love.graphics.newImage( RootTexturePath .."tCrosshair/cross.png")
    tCrossHit = love.graphics.newImage( RootTexturePath .. "tCrosshair/cross-hit.png")
    tCurCross = tCross
    crossScale = 0.15
    hitComboScale = 0.25
    mx = 0
    my = 0
    
    --Main Game UI
    hudForm = MUIForm(love.graphics,"HUDForm")
    
    hudWeaponOneText = CLabel(hudForm,"WeaponOneLabel","WeaponOneLabel",love.graphics.newFont(24))
    table.insert(hudForm.children,hudWeaponOneText)
    hudWeaponTwoText = CLabel(hudForm,"WeaponTwoLabel","WeaponOneLabel",love.graphics.newFont(24))
    table.insert(hudForm.children,hudWeaponTwoText)
    hudWeaponThreeText = CLabel(hudForm,"WeaponThreeLabel","WeaponOneLabel",love.graphics.newFont(24))
    table.insert(hudForm.children,hudWeaponThreeText)
    hudWeaponFourText = CLabel(hudForm,"WeaponFourLabel","WeaponOneLabel",love.graphics.newFont(24))
    table.insert(hudForm.children,hudWeaponFourText)
    
    
    hudWeaponOneIcon = CImage(hudForm,"WeaponOneIcon")
    table.insert(hudForm.children,hudWeaponOneIcon)
    hudWeaponTwoIcon = CImage(hudForm,"WeaponTwoIcon")
    table.insert(hudForm.children,hudWeaponTwoIcon)
    hudWeaponThreeIcon = CImage(hudForm,"WeaponThreeIcon")
    table.insert(hudForm.children,hudWeaponThreeIcon)
    hudWeaponFourIcon = CImage(hudForm,"WeaponFourIcon")
    table.insert(hudForm.children,hudWeaponFourIcon)
    
    hudScore = CLabel(hudForm,"Score","--------",scoreFont)
    hudScore.scalex = 0.25
    hudScore.scaley = 0.25
    
    hudHitCounter = CLabel(hudForm,"Hits",0,scoreFont)
    table.insert(hudForm.children,hudScore)
    table.insert(hudForm.children,hudHitCounter)
    
    hudFPS = CLabel(hudForm,"FpsCounter",0)
    table.insert(hudForm.children,hudFPS)
    
    hudForm:ApplyStylesheet(hudStyle)
  end
  
end

function drawHUD()
  
  love.graphics.draw(hudCanvas)
  
  --Hull
  love.graphics.setColor(0,183,14)
  love.graphics.rectangle( 'fill', (love.graphics.getWidth() / 15) , (love.graphics.getHeight() / 10) * 8.5, 200 * (playerboat.health / playerboat.maxhealth), 30 )
  love.graphics.setColor(10,10,10)
  love.graphics.rectangle( 'line', love.graphics.getWidth() / 15, (love.graphics.getHeight() / 10) * 8.5, 200, 30 )
  love.graphics.setColor(255,255,255)
  
  --Gun One
  love.graphics.setColor(150,40,40)
  love.graphics.rectangle( 'fill', 2*(love.graphics.getWidth() / 10) , (love.graphics.getHeight() / 10) * 9, 200 * (playerboat.GunOneCooldown / playerboat.GunOneCooldownPeroid), 30 )
  love.graphics.setColor(10,10,10)
  love.graphics.rectangle( 'line', 2*(love.graphics.getWidth() / 10), (love.graphics.getHeight() / 10) * 9, 200, 30 )
  love.graphics.setColor(255,255,255)
  
  --Gun Two
  love.graphics.setColor(150,40,40)
  love.graphics.rectangle( 'fill', 4*(love.graphics.getWidth() / 10) , (love.graphics.getHeight() / 10) * 9, 200 * (playerboat.GunTwoCooldown / playerboat.GunTwoCooldownPeroid), 30 )
  love.graphics.setColor(10,10,10)
  love.graphics.rectangle( 'line', 4*(love.graphics.getWidth() / 10), (love.graphics.getHeight() / 10) * 9, 200, 30 )
  love.graphics.setColor(255,255,255)
  
  --Gun Three
  love.graphics.setColor(150,40,40)
  love.graphics.rectangle( 'fill', 6*(love.graphics.getWidth() / 10) , (love.graphics.getHeight() / 10) * 9, 200 * (playerboat.GunThreeCooldown / playerboat.GunThreeCooldownPeroid), 30 )
  love.graphics.setColor(10,10,10)
  love.graphics.rectangle( 'line', 6*(love.graphics.getWidth() / 10), (love.graphics.getHeight() / 10) * 9, 200, 30 )
  love.graphics.setColor(255,255,255)
  
  --Gun Four
  love.graphics.setColor(150,40,40)
  love.graphics.rectangle( 'fill', 8*(love.graphics.getWidth() / 10) , (love.graphics.getHeight() / 10) * 9, 200 * (playerboat.GunFourCooldown / playerboat.GunFourCooldownPeroid), 30 )
  love.graphics.setColor(10,10,10)
  love.graphics.rectangle( 'line', 8*(love.graphics.getWidth() / 10), (love.graphics.getHeight() / 10) * 9, 200, 30 )
  love.graphics.setColor(255,255,255)
  
  
  --Cursor
  hudForm:Draw()
  love.graphics.draw(tCurCross,mx - (tCurCross:getWidth( ) * crossScale / 2) ,my - (tCurCross:getHeight( )  * crossScale / 2),0,crossScale,crossScale)
end

function updateHUD(dt)
  hudForm:Update(dt)
  if hitCombo > bestHitCombo then
    bestHitCombo = hitCombo
  end
  mx, my = love.mouse.getPosition( )
  playerScore = math.floor(playerScore)
  modi = 0
  
  diff = playerScore - displayedScore
  
  modi = diff / 60
  
  displayedScore = displayedScore + modi
  if hitComboScale > 0.25 then
    hitComboScale = hitComboScale - 0.25*dt
  end
  hudScore.text = string.format("%08.0f",displayedScore)
  hudHitCounter.scalex = hitComboScale
  hudHitCounter.scaley = hitComboScale
  hudHitCounter.text = hitCombo
  hudFPS.text =  love.timer.getFPS( ) .. " fps"
end
