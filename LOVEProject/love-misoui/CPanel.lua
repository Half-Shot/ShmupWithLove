--CPanel.lua
require 'love-misoui/control'

CPanel = class('CPanel',MUIControl)

function CPanel:initialize(parent,id)
    MUIControl.initialize(self, parent,id)
    self.type = "Panel"
    self.children = {}
    self.scrollxbehaviour = 'hide'
    self.scrollybehaviour = 'scroll'
    self.borderColor = UIColor:new(0,0,0)
    self.borderWidth = 2
    self.scrollbarwidth = 12
    self.actualHeight = 0
    self.margin = 1
    self.lastmx = 0
    self.lastmy = 0
    self.scrollxpercentage = 0
    self.scrollypercentage = 0
    self.widthoffset = 0
    self.origx = {}
    self.origy = {}
    self.wasDownX = false
    self.wasDownY = false
    self.scrollXButton = CButton:new(this,"ScrollX")
    self.scrollYButton = CButton:new(this,"ScrollY")
    self.scrollXStart = 0
    self.scrollYStart = 0
end

function CPanel:ApplyRule(rule)
    if rule.Name == "scroll-x" then
        self.scrollxbehaviour = rule.Value
    elseif rule.Name == "scroll-y" then
        self.scrollybehaviour = rule.Value
    elseif rule.Name == "border-color" then
        self.borderColor = rule.Value
    elseif rule.Name == "border-width" then
        self.borderWidth = rule.Value
    else 
        CClickable.ApplyRule(self,rule)
    end
end

function CPanel:ApplyStylesheet(style)
    MUIControl.ApplyStylesheet(self,style)
    self.scrollXButton.height = self.scrollbarwidth
    self.scrollYButton.width = self.scrollbarwidth
    self.scrollXButton.y = self.y + self.height - self.scrollbarwidth
    self.scrollYButton.x = self.x + self.width - self.scrollbarwidth
    self.scrollXButton.bgColor = self.fgColor
    self.scrollYButton.bgColor = self.fgColor
    self.scrollXButton.opacity = 255
    self.scrollYButton.opacity = 255
    self.scrollXButton:SetText("||")
    self.scrollYButton:SetText("||")
    self.scrollXButton.x = self.x + self.scrollxpercentage*self.width
    self.scrollYButton.y = self.y + self.scrollypercentage*self.height
    self.scrollXStart = self.x + self.scrollxpercentage*self.width
    self.scrollYStart = self.y + self.scrollypercentage*self.height
end

function CPanel:AddChild(child)
    table.insert(self.children,child)
end

function CPanel:RemoveChild(child)
    table.remove(self.children,child)
end

function CPanel:RefreshChildren()
    self.actualHeight = 0
    local childTotalWidth = 0
    for i,child in pairs(self.children) do
        child.x = self.x + self.borderWidth
        child.y = self.y + self.actualHeight + self.borderWidth
        self.actualHeight = self.actualHeight + child.height + self.margin
        if child.width > childTotalWidth then
            childTotalWidth = child.width
        end
        self.origx[i] = child.x
        self.origy[i] = child.y
    end
    self.scrollXButton.width = math.min(1,self.width/childTotalWidth)*self.width
    self.scrollYButton.height = math.min(1,self.height/self.actualHeight)*self.height
end

function CPanel:Update(dt)
  MUIControl.Update(self,dt)
  --Hide/Show Children
  local childTotalWidth = 1
  local childTotalHeight = 1
  local heightoffst = 0
  for i,child in pairs(self.children) do
    heightoffst = self.actualHeight + child.height + self.margin
    child.y = self.origy[i] - (self.scrollypercentage*(self.actualHeight-self.height))
    childTotalHeight = childTotalHeight + child.height
    local should = (child.x + child.width > self.x) and (child.x < self.x + self.width) and (child.y + child.height > self.y) and (child.y < self.y + self.height)
    child.shoulddraw = should
    child.shouldupdate = should
    
    
  end
  self.scrollx = ((childTotalWidth > self.width and self.scrollxbehaviour == 'scroll') or self.scrollxbehaviour == 'always')
  self.scrolly = ((childTotalHeight > self.height and self.scrollybehaviour == 'scroll') or self.scrollybehaviour == 'always')
  
    for _,child in pairs(self.children) do
        if child.shouldupdate then
            child:Update(dt)
        end
    end
  local mousex,mousey = love.mouse.getPosition()
  --X Movement
  if self.scrollx then
    self.scrollXButton:Update(dt)
    if (self.width - self.scrollXButton.width) > 0 then
      if self.scrollXButton.begunpress then
            self.lastmx = mousex
      elseif self.scrollXButton.pressedIn then
        local xmovement = mousex - self.lastmx
        self.lastmx = mousex
        self.scrollXButton.x = math.clamp(self.scrollXStart,self.scrollXButton.x+xmovement,self.width - self.scrollXButton.width)
        self.scrollxpercentage = self.scrollXButton.x / (self.width - self.scrollXButton.width)
      end
    end
  end
  
  if self.scrolly then
      self.scrollYButton:Update(dt)
      if (self.height - self.scrollYButton.height) > 0 then
          if self.scrollYButton.begunpress then
                self.lastmy = mousey
          elseif self.scrollYButton.pressedIn then
            local ymovement = mousey - self.lastmy
            self.lastmy = mousey
            self.scrollYButton.y = math.clamp(self.scrollYStart,self.scrollYButton.y+ymovement,self.height + self.y - self.scrollYButton.height)
            self.scrollypercentage = (self.scrollYButton.y - self.y) / (self.height - self.scrollYButton.height)
            print((self.scrollYButton.y - self.y))
            print((self.height - self.scrollYButton.height))
            print(self.scrollypercentage)
          end
      end
  end
end

function CPanel:Stencil()
    love.graphics.rectangle('fill',currentPanel.x,currentPanel.y,currentPanel.width,currentPanel.height)
end
function CPanel:Draw()
    love.graphics.setLineWidth( self.borderWidth )
    love.graphics.setColor(self.bgColor.R,self.bgColor.G,self.bgColor.G,self.opacity)
    love.graphics.rectangle('fill',self.x,self.y,self.width,self.height)
    love.graphics.setColor(self.borderColor.R,self.borderColor.G,self.borderColor.G,self.opacity)
    love.graphics.rectangle('line',self.x,self.y,self.width,self.height)
    currentPanel = self
    love.graphics.setStencil(self.Stencil)
    for _,child in pairs(self.children) do
        if child.shoulddraw then
            child:Draw()
        end
    end
    currentPanel = nil
    love.graphics.setStencil()
    if self.scrollx then
        self.scrollXButton:Draw()
    end
    if self.scrolly then
        self.scrollYButton:Draw()
    end
    love.graphics.setColor(self.fgColor.R,self.fgColor.G,self.fgColor.G,self.opacity)
    love.graphics.setLineWidth( 1 )
end
