--entityman.lua
local class = require 'middleclass/middleclass'
EntityManager = class('EntityManager')

function EntityManager:initialize()
    self.entitylist = {}
    print("New Entity Manager Created")
end

function EntityManager:Add(entity)
    table.insert(self.entitylist,entity)
    return 
end

function EntityManager:Remove(entity)
    index = -1
    for k, v in pairs(self.entitylist) do
      if v == entity then
        index = k
        break
      end
    end
    if index > -1 then
      self.entitylist[index]:destroyed()
      table.remove(self.entitylist,index)
    else
      return false
    end
end

function EntityManager:Get(name)
    for k, v in pairs(self.entitylist) do
      if v.name == name then
        return v
      end
    end
end

function EntityManager:Update(dt)
    for k, v in pairs(self.entitylist) do
        v:update(dt)
        if v.remove then
            self:Remove(v)
        end
    end
end

function EntityManager:Draw()
    for k, v in pairs(self.entitylist) do
        v:draw()
    end
end

function EntityManager:Destroy()
    for k, v in pairs(self.entitylist) do
        v:destroyed()
    end
end
