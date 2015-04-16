--state.lua
State = class('State')
function State:initialize(name,onset,onunset,conflicts,conflictsall)
    self.name = name
    self.onset = onset --Params: Removed States
    self.onunset = onunset --Params: Added State
    self.conflicts = conflicts
    if conflictsall ~= nil then
        self.conflictsall = conflictsall
    else
        self.conflictsall = false
    end
end

StateHandler = class('StateHandler')
function StateHandler:initialize(startstate,states)

    
    if states == nil then
        states = {}
    end
    self.states = states
    self.statetype = stype
    self.__currentstate = {}
    if startstate ~= nil then
        self:SetState(startstate)
    end
end

function StateHandler:SetState(state)
    local statetoset = state
    
    if type(state) == "string" then
        for _,v in pairs(self.states) do
            if v.name == state then
                statetoset = state
            end
        end
    end 
    
    --State already exists.
    for _,state in pairs(self.__currentstate) do
        if state == statetoset then
            return false
        end
    end
    local removedstates = {}
    --Remove conflicting states
    for i,state in pairs(self.__currentstate) do
        if statetoset.conflictsall then
            if state.onunset ~= nil then
                state.onunset(statetoset)
            end
            table.insert(removedstates,state)
            table.remove(self.__currentstate,i)
        else
            for _,v in pairs(state.conflicts) do
                if v == statetoset then
                    if v.onunset ~= nil then
                        v.onunset(statetoset)
                    end
                    table.insert(removedstates,state)
                    table.remove(self.__currentstate,i)
                end
            end
        end
    end
    
    table.insert(self.__currentstate,statetoset)
    if statetoset.onset ~= nil then
        statetoset.onset(removedstates)
    end
    return true
end

function StateHandler:HasState(state)
    local statetocheck = state
    if type(state) == "string" then
        for _,v in pairs(self.states) do
            if v.name == state then
                statetoset = state
            end
        end
    end 
    for _,state in pairs(self.__currentstate) do
        if type(statetocheck) == "table" then
            for _,st in pairs(statetocheck) do
                if st == state then
                    return true
                end
            end
        end
        if state == statetocheck then
            return true
        end
    end
    return false
end
