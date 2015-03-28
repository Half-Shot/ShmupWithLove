--entityman.lua
local class = require 'middleclass/middleclass'
EntityManager = class('EntityManager')

function EntityManager:initialize()
    self.entitylist = {}
    print("New Entity Manager Created")
end
