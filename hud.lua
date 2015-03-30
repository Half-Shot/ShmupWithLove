--hud.lua

function drawHUD()
  --Score
  love.graphics.setFont(scoreFont)
  love.graphics.print(string.format("%08.0f",playerScore) , love.graphics.getWidth() / 20, love.graphics.getHeight() / 20,0,0.25,0.25)
  love.graphics.setNewFont(12)
  --Gun One
  love.graphics.setColor(10,10,10)
  love.graphics.rectangle( 'line', love.graphics.getWidth() / 15, (love.graphics.getHeight() / 10) * 9, 200, 30 )
  love.graphics.setColor(150,40,40)
  love.graphics.rectangle( 'fill', (love.graphics.getWidth() / 15) , (love.graphics.getHeight() / 10) * 9, 200 * (playerboat.GunOneCooldown / playerboat.GunOneCooldownPeroid), 30 )
  love.graphics.setColor(255,255,255)
end
