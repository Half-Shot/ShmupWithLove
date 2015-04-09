--leveleditor.lua
tileSelectHandler =  function(i)
  edselectedTexture = i
end

EditorLoadFile = function()
  fileLocation = editfilepath.text
  editName,editAuthor,Level = loadLevel("levels/"..fileLocation..".swl")
  if Level == nil then
    --Try Save Directory
    editName,editAuthor,Level = loadLevel(FILE_USERLEVELS .. "/"..fileLocation..".swl")
  end
  
  if Level ~= nil then
    setLevel(Level)
  else
    print("Couldn't find file.")
  end
end

EditorSaveFile = function()
  fileLocation = FILE_USERLEVELS .. "/" .. editfilepath.text ..".swl"
  saveLevel(fileLocation,Level,editName,editAuthor)
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
edMode = 'draw' -- draw,fill
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
  editfilepath = CTextbox(editorForm,"FilePath")
  local editfilepathl = MUILabel(editorForm,"FilePathLabel")
  editcords = MUILabel(editorForm,"MapCords")
  --Tools
  local editdraw = CButton(editorForm,"ToolDraw")
  local editfill = CButton(editorForm,"ToolFill")
  
  local editmvup = CButton(editorForm,"MoveMapUp")
  local editmvdown = CButton(editorForm,"MoveMapDown")
  local edittoggrid = CButton(editorForm,"ToggleGrid")
  edittoggrid.clickfunction = function() edShowGrid = (edShowGrid == false) end
  editdraw.clickfunction = function() edMode='draw' end
  editfill.clickfunction = function() edMode='fill' end
  
  editmvup.clickfunction = edscrollMap
  editmvup.clickvalue = 1
  editmvdown.clickfunction = edscrollMap
  editmvdown.clickvalue = -1
  
  editnewLevel.clickfunction = function()   _,_,Level = loadLevel("levels/template.swl") setLevel(Level) end
  table.insert(editorForm.children,editnewLevel)
  table.insert(editorForm.children,editloadLevel)
  table.insert(editorForm.children,editsaveLevel)
  table.insert(editorForm.children,edittest)
  table.insert(editorForm.children,editdraw)
  table.insert(editorForm.children,editfill)
  table.insert(editorForm.children,editmvup)
  table.insert(editorForm.children,editmvdown)
  table.insert(editorForm.children,editcords)
  table.insert(editorForm.children,edittoggrid)
  table.insert(editorForm.children,editfilepath)
  table.insert(editorForm.children,editfilepathl)
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
end

function editorUpdate(dt)
    editorForm:Update(dt)
    mx = (love.mouse.getX( ) - love.graphics.getWidth()/10) * 1.25
    my = (love.mouse.getY( ) - love.graphics.getHeight()/10) * 1.25
    editcords.text = string.format("X:%02d,Y:%02d",selectedTileX,LevelWidth-selectedTileY+tileRow)
    if love.mouse.isDown( 'wu' ) then
      print("scroll")
      edscrollMap(1)
    elseif love.mouse.isDown( 'wd' ) then
      edscrollMap(-1)
    end
    
    if love.keyboard.isDown( 'pageup' ) then
      edscrollMap(5)
    elseif love.keyboard.isDown( 'pagedown' ) then
      edscrollMap(-5)
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
              end
            end
            for x=selectedTileX+1,LevelWidth do
              if Level[y][x][1] ~= curTex then
                break
              else
                Level[y][x][1] = edTileToSet
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
      for w=1,LevelWidth do
        for h=1,LevelWidth do
          love.graphics.setColor(255,255,255,150)
          love.graphics.line(w*scX,0,w*scX,love.graphics.getHeight()) --Top
          love.graphics.line(0,h*scY,love.graphics.getWidth(),h*scY) --Left
          love.graphics.setColor(137,137,20,5)
          love.graphics.rectangle( 'fill', (selectedTileX-1)*scX, (selectedTileY-1)*scY, scX, scY )
          love.graphics.setColor(255,255,255,255)
        end
      end
    end
    love.graphics.setCanvas()
end
