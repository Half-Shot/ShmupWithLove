--helper.lua
function lerp(a,b,t) return (1-t)*a + t*b end

function string.starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

function string.ends(String,End)
   return End=='' or string.sub(String,-string.len(End))==End
end

function math.clamp(low, n, high)
   return math.min(math.max(low, n), high)
end
