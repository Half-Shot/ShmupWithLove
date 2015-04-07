--CButton.lua
require 'love-misoui/control'
local class = require 'middleclass/middleclass'
CButton = class('CButton',CClickable)

function CButton:initialize(parent,id)
    CClickable.initialize(self, parent,id)
    self.type = "Button"
    self.text = ""
    self.btnDrawCol = UIColor:new()
    self.btnDrawCol.R = self.bgColor.R
    self.btnDrawCol.G = self.bgColor.G
    self.btnDrawCol.B = self.bgColor.B
    self.font = love.graphics.newFont(12)
end

function CButton:SetText(text)
        self.text = text
        self.textWidth = love.graphics.getFont( ):getWidth(text)
        self.textHeight = love.graphics.getFont( ):getHeight(text)
end

function CButton:ApplyRules(rules)
  CClickable.ApplyRules(self,rules)
  if self.shouldupdate == false then
    self.btnDrawCol.R = self.bgColor.R - 20
    self.btnDrawCol.G = self.bgColor.G - 20
    self.btnDrawCol.B = self.bgColor.B - 20
  end
end

function CButton:ApplyRule(rule)
    if rule.Name == "content" then
      self:SetText(rule.Value)
    else
        CClickable.ApplyRule(self,rule)
    end
end

function CButton:Update(dt)
    CClickable.Update(self, dt)
    if self.clicked then
      self.btnDrawCol.R = self.bgColor.R + 40
      self.btnDrawCol.G = self.bgColor.G + 40
      self.btnDrawCol.B = self.bgColor.B + 40
    elseif self.hovered then
      self.btnDrawCol.R = self.bgColor.R + 10
      self.btnDrawCol.G = self.bgColor.G + 10
      self.btnDrawCol.B = self.bgColor.B + 10
    else
      self.btnDrawCol.R = self.bgColor.R
      self.btnDrawCol.G = self.bgColor.G
      self.btnDrawCol.B = self.bgColor.B
    end
end

function CButton:Draw()
    --Fallback drawing method
    love.graphics.setColor(self.btnDrawCol.R,self.btnDrawCol.G,self.btnDrawCol.B,self.opacity)
    love.graphics.rectangle("fill",self.x,self.y,self.width,self.height)
    
    if self.text ~= nil then
      love.graphics.setColor(self.fgColor.R,self.fgColor.G,self.fgColor.B,self.opacity)
      prevFont = love.graphics.getFont()
      if self.font ~= nil then
          love.graphics.setFont(self.font)
      end
      love.graphics.print(self.text,self.x + (self.width - self.textWidth) / 2,self.y  + (self.height - self.textHeight) / 2)
      love.graphics.setFont(prevFont)
    end
    love.graphics.setColor(255,255,255)
end
