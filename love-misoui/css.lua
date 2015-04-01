require 'love-misoui/ruleset'

--DeclarationType
muiDeclarationType = {"Type","Class","Id"}
--RuleType
muiRuleType = {"Unknown","Integer","Pixel","Percentage","Color","String"}
--CSSState
muiCSSState = {"LookingForSelector","ReadingRules"}

function trim(s)
  -- from PiL2 20.4
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

--From https://gist.github.com/jasonbradley/4357406
function hex2rgb(hex)
    hex = hex:gsub("#","")
    return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
end 

--Returns Ruleset
function MUI_parseSheet(fileName)
    contents = love.filesystem.read(fileName)
    if contents == nil then
        error("Couldn't load file " .. fileName)
    end
    return MUI_parseCSS(contents)
end

function MUI_parseCSS(sourceCss)
    sourceCss = sourceCss:gsub( "/%*.*%*/", "" ) --Remove Comments 
    local rulesets = {}
    local state = muiCSSState[1]
    local i = 1
    local openBraketIndex = 0
    local selector = ""
    local currentRuleset = nil
    local declrType = muiDeclarationType[1]
    local length = sourceCss:len()
    while i < length do
        --Fix magic character bullshit
        value = string.byte(sourceCss:sub(i,i))
        while value > 128 do
            i = i + 1
            value = string.byte(sourceCss:sub(i,i))
        end
        if state == muiCSSState[1] then
            local openBracketIndex = sourceCss:find('{',i)
            if i == openBracketIndex or openBracketIndex == nil then
                i = length
                break;
            end
            local selector = sourceCss:sub(i,openBracketIndex - 1)
            selector = trim(selector)
            local ident = selector:sub(1,1)
            if ident == '#' then
                declrType = muiDeclarationType[3]
                selector = selector:sub(2)
            elseif ident == '.' then
                declrType = muiDeclarationType[2]
                selector = selector:sub(2)
            else
                declrType = muiDeclarationType[1]
                selector = selector:sub(1)
            end
            
            i = openBracketIndex + 1
            currentRuleset = Ruleset:new(declrType,selector)
            state = muiCSSState[2]
        elseif state == muiCSSState[2] then
            local semiColonIndex = sourceCss:find(';',i)
            local rulesetEndPoint = sourceCss:find('}',i)
            while semiColonIndex ~= nil and rulesetEndPoint > semiColonIndex do
                local statement = sourceCss:sub(i,semiColonIndex - 1)
                statement = trim(statement)
                statement = MUI_parseStatement(statement)
                if statement ~= nil then
                    table.insert(currentRuleset.rules,statement)
                end
                i = semiColonIndex + 1
                semiColonIndex = sourceCss:find(';',i)
            end
            i = rulesetEndPoint + 1
            state = muiCSSState[1]
            table.insert(rulesets,currentRuleset)
        end
    end
    return rulesets
end

--Returns Rule
function MUI_parseStatement(statement)
    local colonpos = statement:find(':')
    local atype = muiRuleType[1]
    if colonpos == nil then
        error("CSS Statement missing a ':' (" ..statement .. ")")
    end
    local key = statement:sub(1,colonpos-1)
    local value = statement:sub(colonpos+1)
    local thestart = value:sub(1,1)
    local theend = value:sub(value:len())
    if thestart == '"' and theend == '"' then
        atype = muiRuleType[6]
        value = value:sub(2,value:len() - 1)
    elseif theend == '%' then
        value = tonumber(value)
        atype = muiRuleType[4]
    elseif value:sub(value:len() - 1) == 'px' then
        value = tonumber(value:sub(1,value:len() - 2))
        atype = muiRuleType[3]
    elseif thestart == '#' then
        atype = muiRuleType[5]
        r,g,b = hex2rgb(value)
        value = UIColor:new(r,g,b)
    elseif value:match("%A+") == nil then
        local hex = muiColorList[value]
        if hex == nil then
            print("Color '"..value.."' is not from the standard CSS3 set. It will show up as pink")
            hex = muiColorList["Pink"]
        end
        r,g,b = hex2rgb(hex)
        value = UIColor:new(r,g,b)
        atype = muiRuleType[5]
    else
        atype = muiRuleType[2]
        value = tonumber(value)
    end
    return Rule:new(key,atype,value)
end
