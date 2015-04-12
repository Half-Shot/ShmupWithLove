--leveleditor.lua
tileSelectHandler =  function(i)
  edselectedTexture = i
end

EditorLoadFile = function()
  fileLocation = editfilepath.text
  nm,au,Level = loadLevel("levels/"..fileLocation..".swl")
  if Level == nil then
    --Try Save Directory
    nm,au,Level = loadLevel(FILE_USERLEVELS .. "/"..fileLocation..".swl")
  end
  if Level ~= nil then
    setLevel(Level)
    editauthor.text = nm
    editname.text = au
  else
    print("Couldn't find file.")
  end
end

EditorSaveFile = function()
  fileLocation = FILE_USERLEVELS .. "/" .. editfilepath.text ..".swl"
  saveLevel(fileLocation,Level,editname.text,editauthor.text)
end

edscrollMap = function(a)
  if (tileRow > 2 + (a*-1) and a < 0) or (a > 0 and tileRow < tileLevelLength - tileTotalWidth - a - tileBuffer) then
    tileRow = tileRow + a
  end
end
edShowGrid = true
edselectedTexture = 0
editName = "Name"
editAuthor = "Author"
edMode = 'draw' -- draw,fill,entity
edRotation = 0
edRotateButtonDown = false
function editorLoad()
  styMenu = MUI_parseSheet("css/editor.css")
  editorForm = MUIForm(love.graphics,"editorForm")
  --Toolbar
  local editnewLevel = CButton(editorForm,"NewLevel")
  local editloadLevel = CButton(editorForm,"LoadLevel")
  editloadLevel.clickfunction = EditorLoadFile
  local editsaveLevel = CButton(editorForm,"SaveLevel")
  editsaveLevel.clickfunction = EditorSaveFile
  local edittest = CButton(editorForm,"TestLevel")
  edittest.clickfunction = testLevel
  local editback = CButton(editorForm,"BackToMenu")
  editback.clickfunction = function() gameState = 'menu' end
  editfilepath = CTextbox(editorForm,"FilePath")
  local editfilepathl = CLabel(editorForm,"FilePathLabel")
  editcords = CLabel(editorForm,"MapCords")
  --Tools
  local editdraw = CButton(editorForm,"ToolDraw")
  local editfill = CButton(editorForm,"ToolFill")
  local editentadd = CButton(editorForm,"ToolAddEntity")
  
  
  local editauthorl = CLabel(editorForm,"AuthorLabel")
  local editnamel = CLabel(editorForm,"NameLabel")
  editauthor = CTextbox(editorForm,"Author")
  editname = CTextbox(editorForm,"Name")
  
  local editmvup = CButton(editorForm,"MoveMapUp")
  local editmvdown = CButton(editorForm,"MoveMapDown")
  local edittoggrid = CButton(editorForm,"ToggleGrid")
  
  local editentitylist = CPanel(editorForm,"EntityList")
  
  table.insert(editorForm.children,editnewLevel)
  table.insert(editorForm.children,editloadLevel)
  table.insert(editorForm.children,editsaveLevel)
  table.insert(editorForm.children,edittest)
  table.insert(editorForm.children,editdraw)
  table.insert(editorForm.children,editfill)
  table.insert(editorForm.children,editentadd)
  table.insert(editorForm.children,editmvup)
  table.insert(editorForm.children,editmvdown)
  table.insert(editorForm.children,editcords)
  table.insert(editorForm.children,edittoggrid)
  table.insert(editorForm.children,editfilepath)
  table.insert(editorForm.children,editfilepathl)
  table.insert(editorForm.children,editback)
  table.insert(editorForm.children,editauthorl)
  table.insert(editorForm.children,editnamel)
  table.insert(editorForm.children,editauthor)
  table.insert(editorForm.children,editname)
  table.insert(editorForm.children,editentitylist)
  
  editorForm:ApplyStylesheet(styMenu)
  for i=1,10 do
    for i,def in pairs(EntityDefinition) do
      local editentbutton = CButton(editentitylist,"EntitySelectButton")
      editentbutton:SetText(def.static.name)
      editentbutton.clickfunction = function(i) edCurrentEnt = i end
      editentbutton.clickvalue = i
      editentitylist:AddChild(editentbutton)
    end
  end
  editentitylist:ApplyStylesheet(styMenu)
  editentitylist:RefreshChildren()
  
  edittoggrid.clickfunction = function() edShowGrid = (edShowGrid == false) end
  editdraw.clickfunction = function() edMode='draw' end
  editfill.clickfunction = function() edMode='fill' end
  editentadd.clickfunction = function() edMode='entity' end
  editmvup.clickfunction = edscrollMap
  editmvup.clickvalue = 1
  editmvdown.clickfunction = edscrollMap
  editmvdown.clickvalue = -1
  
  editnewLevel.clickfunction = function()   _,_,Level = loadLevel("levels/template.swl") setLevel(Level) end
  
  --Simple Tile Bar
  for i,tile in pairs(tileset) do
    local tileSelect = CButton(editorForm,"TileSelectButton")
    tileSelect.clickvalue = i
    tileSelect.clickfunction = tileSelectHandler
    table.insert(editorForm.children,tileSelect)
  end
  editorForm:ApplyStylesheet(styMenu)
  local w = -1
  local ri = 0
  local h = -2.5
  for i,v in pairs(editorForm.children) do
    if v.id == "TileSelectButton" then
      if w == -1 then
        w = i
        ri = i
      end
      local newW = (i-w)*v.width
      local newH = v.y + (h*v.height)
      if newW + v.width > love.graphics.getWidth() then
        w = i
        h = h + 1
        newW = (i-w)*v.width
        newH = v.y + (h*v.height)
      end
      v.x = newW
      v.y = newH
      --v.SetText(i-ri+1)
      v.image = tileset[i-ri+1]
    end
  end
  _,_,Level = loadLevel("levels/template.swl")
  setLevel(Level)
  LevelWidth = table.getn(Level[1])
  tileSpeed = 0
  selectedTileX = 1
  selectedTileY = 1
  scX = love.graphics.getWidth()/LevelWidth
  scY = love.graphics.getHeight()/LevelWidth
  
  
  editGrid = love.graphics.newCanvas(love.graphics.getWidth(),love.graphics.getHeight())
  love.graphics.setCanvas(editGrid)
  for w=1,LevelWidth do
    for h=1,LevelWidth do
      love.graphics.setColor(255,255,255,150)
      love.graphics.line(w*scX,0,w*scX,love.graphics.getHeight()) --Top
      love.graphics.line(0,h*scY,love.graphics.getWidth(),h*scY) --Left
    end
  end
  love.graphics.setCanvas()
  
end

function love.mousepressed(x, y, button)
   if gameState == "editor" then
    if button == 'wu' then
      edscrollMap(1)
    elseif button ==  'wd' then
      edscrollMap(-1)
    end
   end
end

function editorUpdate(dt)
    editorForm:Update(dt)
    mx = (love.mouse.getX( ) - love.graphics.getWidth()/10) * 1.25
    my = (love.mouse.getY( ) - love.graphics.getHeight()/10) * 1.25
    editcords.text = string.format("X:%02d,Y:%02d",selectedTileX,LevelWidth-selectedTileY+tileRow)

    if love.keyboard.isDown( 'pageup' ) then
      edscrollMap(5)
    elseif love.keyboard.isDown( 'pagedown' ) then
      edscrollMap(-5)
    end
    
    
    if love.mouse.isDown( 'm') then
      edRotateButtonDown = true
    elseif edRotateButtonDown == true then
      edRotation = edRotation + 90
      if edRotation > 270 then
        edRotation = 0
      end
      edRotateButtonDown = false
    end
     
    sTX = math.floor(mx / scX) + 1
    sTY = math.floor(my / scY) + 1
    if sTX > 0 and sTX <= LevelWidth and sTY > 0 and sTY <= LevelWidth then
      selectedTileX = sTX
      selectedTileY = sTY
      if love.mouse.isDown( 'l' ) or love.mouse.isDown( 'r' ) then
        if love.mouse.isDown( 'l' ) then
          edTileToSet = edselectedTexture
        else
          edTileToSet = 0
        end
        curTex = Level[LevelWidth-selectedTileY+2][selectedTileX][1] 
        if edMode == 'draw' then
          Level[LevelWidth-selectedTileY+tileRow-1][selectedTileX][1] = edTileToSet
          Level[LevelWidth-selectedTileY+tileRow-1][selectedTileX][2] = edRotation
        elseif edMode == 'fill' then
          --Get Bounds
          YTile = LevelWidth-selectedTileY+tileRow-1
          --Find Y Bounds
          for i=YTile,1,-1 do
            YLower = i
            if Level[i][selectedTileX][1] ~= curTex then
              break
            end
          end
          for i=YTile+1,tileLevelLength do
            YUpper = i
            if Level[i][selectedTileX][1] ~= curTex then
              break
            end
          end
          for y=YLower,YUpper do
            for x=selectedTileX,1,-1 do
              if Level[y][x][1] ~= curTex then
                break
              else
                Level[y][x][1] = edTileToSet
                Level[y][x][2] = edRotation
              end
            end
            for x=selectedTileX+1,LevelWidth do
              if Level[y][x][1] ~= curTex then
                break
              else
                Level[y][x][1] = edTileToSet
                Level[y][x][2] = edRotation
              end
            end
          end
        end
      end
    end
    tileUpdate(dt)
end

function editorDraw()
    --Draw Grid
    foreGround:clear()
    editorForm:Draw()
    love.graphics.setCanvas(foreGround)
    drawWater()
    tileDraw()
    if edShowGrid then
      love.graphics.draw(editGrid)
      love.graphics.setColor(137,137,20,150)
      love.graphics.rectangle( 'fill', (selectedTileX-1)*scX, (selectedTileY-1)*scY, scX, scY )
      love.graphics.setColor(255,255,255,255)
    end
    love.graphics.setCanvas()
end
