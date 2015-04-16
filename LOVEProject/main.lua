require 'include'
FILE_USERLEVELS = "custom/levels"
GameVersionString = "ShmupWithLove v0.06"
projectileSlot = 0
projectileList = {}
playerScore = 0
lights = {}
levelEnts = {}
function setupNewGame()
  if GameState:HasState(stGame) then
    print("Starting new mission.")
    file = selectedLevel[1] 
    Name,Author,levelData,levelEnts = loadLevel(file)
    setLevel(levelData)
    wsMode = 'map'
  end
  loadHUD()
  love.mouse.setVisible(false)
  playerboat = PlayerBoat:new()
  entityManager = EntityManager:new()
  waveSpawnerLoad()
  playerboat:load()
  playerScore = 0
  projectileList = {}
  projectileSlot = 0
  tileSpeed = 1
  tilePosition = 0
  tileRow = 3
end

function ChangeResolution(w,h)
  love.window.setMode(w,h)
  reflectionBufferA = love.graphics.newCanvas(love.graphics.getWidth(), love.graphics.getHeight())
  reflectionBufferB = love.graphics.newCanvas(love.graphics.getWidth(), love.graphics.getHeight())
  water = love.graphics.newCanvas(love.graphics.getWidth(), love.graphics.getHeight())
  foreGround = love.graphics.newCanvas(love.graphics.getWidth(), love.graphics.getHeight())
  hudCanvas = love.graphics.newCanvas(love.graphics.getWidth(), love.graphics.getHeight())
  lights[1].x = love.graphics.getWidth()/2
  lights[1].y = love.graphics.getHeight()/2
  blankMax = love.graphics.newImage(love.image.newImageData( love.graphics.getWidth(), love.graphics.getHeight() ))
end

function love.load()
  --One off things
  love.filesystem.setIdentity( "ShmupWithLove" ) 
  love.filesystem.createDirectory( FILE_USERLEVELS )
  waterDistort = love.math.newRandomGenerator( )
  amanager = AnimationManager:new()
  love.audio.setVolume(0.8)
  love.graphics.setBackgroundColor(0,0,0)
  loadWater()
  loadFonts()
  loadTiles()
  getLevels(FILE_USERLEVELS)
  getLevels("levels")
  selectedLevel = gameLevels[1]
  for i=1,8 do
    lights[i] = Light:new(0,0,0,0)
  end
  ChangeResolution(1920,1080)
  check = love.graphics.newImage(RootTexturePath .. "tTest/check.jpg")
  pEnemyHit = love.graphics.newParticleSystem(love.graphics.newImage( RootTexturePath .. "tEnemyBoat/chunk.png"), 32);
  pEnemyHit:setParticleLifetime(0.5, 1.5); -- Particles live at least 2s and at most 5s.
  pEnemyHit:setLinearAcceleration( -250, -250, 250, 250 )
  pEnemyHit:setColors(255, 255, 255, 255, 255, 255, 255, 0); -- Fade to black.
  pEnemyHit:setSizes( 0.25 )
  pEnemyHit:setSpin( -math.pi, math.pi )
  --Sunlight
  lights[1].R = 187
  lights[1].G = 237
  lights[1].B = 255
  lights[1].A = 225
  -- Generate blank textures
  blank32 = love.graphics.newImage(love.image.newImageData( 32, 32 ))
  blank64 = love.graphics.newImage(love.image.newImageData( 64, 64 ))
  blank128 = love.graphics.newImage(love.image.newImageData( 128, 128 ))
  blank256 = love.graphics.newImage(love.image.newImageData( 256, 256 ))
  tProjMissilePlayer = love.graphics.newImage( RootTexturePath .. "tProjectiles/tMissile.png")
  tPUPFixCrate = love.graphics.newImage( RootTexturePath .. "tPowerups/FixCrate.png")
  tPUPCrate = love.graphics.newImage( RootTexturePath .. "tPowerups/Crate.png")
  
  --States
  stMenu = State:new('menu',loadMenu,nil,{},true)
  stMenu = State:new('settingsmenu',loadSettingsMenu,nil,{},true)
  stGame = State:new('game',setupNewGame,nil,{},true)
  stGameOver = State:new('gameover',loadGameOverMenu,nil,{},true)
  stLevelEditor = State:new('leveleditor',editorLoad,nil,{},true)
  stTestLevel = State:new('testlevel',setupNewGame,nil,{},true)
  GameState = StateHandler:new(stMenu,{stMenu,stGame,stGameOver,stLevelEditor,stTestLevel})
  
  
end


function love.update(dt)
  updateWater(dt)
  amanager:update(dt)
  if GameState:HasState(stGame) then
   UpdateGame(dt,false)
  elseif GameState:HasState(stTestLevel) then
   UpdateGame(dt,true)
  elseif GameState:HasState(stLevelEditor) then
    editorUpdate(dt)
  elseif GameState:HasState(stMenu) then
    updateMenu(dt)
  end
  if GameState:HasState(stGameOver) then
    updateHUD(dt)
    sReflectionLayer:send("distort",0.1)
    goForm:Update(dt)
  end
end

function love.draw()
  if GameState:HasState({stGame,stGameOver,stTestLevel}) then
    DrawGame()
    if GameState:HasState(stGameOver) then
      goForm:Draw()
    end
    drawHUD()
  elseif GameState:HasState(stLevelEditor) then
    love.graphics.draw(foreGround,love.graphics.getWidth()/10,love.graphics.getHeight()/10,0,0.8,0.8)
    editorDraw()
  elseif GameState:HasState(stMenu) then
    drawWater() -- Background
    drawMenu()
  end
  
  
end


function drawBlur()
    reflectionBufferA:clear()
    love.graphics.setCanvas(reflectionBufferA)
    love.graphics.draw(foreGround)
    love.graphics.setShader(sReflectionLayer)
    for i=1,4 do
      reflectionBufferB:clear()
      love.graphics.setCanvas(reflectionBufferB)
      love.graphics.draw(reflectionBufferA)
      reflectionBufferA:clear()
      love.graphics.setCanvas(reflectionBufferA)
      love.graphics.draw(reflectionBufferB)
    end
    love.graphics.setCanvas()
    love.graphics.setShader()
end
