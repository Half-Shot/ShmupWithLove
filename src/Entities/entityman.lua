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

function EntityManager:CountOfType(classType,includesubclasses)
    local count = 0
    for _,ent in pairs(self.entitylist) do
        if class.Object.isInstanceOf(ent, classType) then
            count = count + 1
        elseif includesubclasses and class.Object.isSubclassOf(classType, ent) then
            count = count + 1
        end
    end
    return count
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
