--mainmenu.lua

require 'love-misoui/main'
backToMenuCallback = function ()
		GameState:SetState(stMenu)
    print("Going to menu.")
end

quitGameCallback = function ()
    print("Exiting game. Goodbye")
    love.event.quit( )
end

singlePlayerMissionCallback = function ()
	GameState:SetState(stGame)
end

    --Game Over Screen UI
function loadGameOverMenu()
  if goForm == nil then
    goStyle = MUI_parseSheet("css/gameover.css")
    goForm = MUIForm(love.graphics,"gameOverForm")
    gogameOverText = CLabel(goForm,"gameOverText","%TITLE%",nil)
    
    goscore = CLabel(goForm,"gameOverScore",0,love.graphics.newFont(32))
    godeaths = CLabel(goForm,"gameOverDeaths",0,love.graphics.newFont(24))
    gosurvivors = CLabel(goForm,"gameOverSurvivors",0,love.graphics.newFont(24))
    gocombo = CLabel(goForm,"gameOverTopCombo",0,love.graphics.newFont(24))
    
    goMenuButton = CButton(goForm,"MenuButton")
    goMenuButton.clickfunction = backToMenuCallback
    table.insert(goForm.children,gogameOverText)
    table.insert(goForm.children,goscore)
    table.insert(goForm.children,godeaths)
    table.insert(goForm.children,gosurvivors)
    table.insert(goForm.children,gocombo)
    table.insert(goForm.children,goMenuButton)
    goForm:ApplyStylesheet(goStyle)
  end
end

function loadMenu()
  print("Load Menu")
  love.mouse.setVisible(true)
  if form == nil then
    styMenu = MUI_parseSheet("css/menu.css")
    form = MUIForm(love.graphics,"menuForm")
    version = CLabel(form,"versionInfo",GameVersionString,nil)
    missionButton = CButton(form,"SelectMissionButton")
    missionButton.clickfunction = singlePlayerMissionCallback
    onlineMissionButton = CButton(form,"OnlineMissionButton")
    quitButton = CButton(form,"QuitButton")
    settingsButton = CButton(form,"SettingsButton")
    aboutButton = CButton(form,"AboutButton")
    editorButton = CButton(form,"EditorButton")
    quitButton.clickfunction = quitGameCallback
    editorButton.clickfunction = function() GameState:SetState(stLevelEditor) end
    table.insert(form.children,version)
    table.insert(form.children,missionButton)
    table.insert(form.children,onlineMissionButton)
    table.insert(form.children,quitButton)
    table.insert(form.children,settingsButton)
    table.insert(form.children,aboutButton)
    table.insert(form.children,editorButton)
    form:ApplyStylesheet(styMenu)
  end
end

function updateMenu(dt)
    form:Update(dt)
end

function drawMenu()
    form:Draw(dt)
end
