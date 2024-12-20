local min = math.min
local max = math.max
local sin = math.sin
local cos = math.cos
local radians = math.rad

local function clamp (x, a, b)
	return max(a, min(x, b))
end

math.clamp = clamp

function math.sico (angle)
	return sin(angle), cos(angle)
end


function math.clampSym (x, radius)
	return clamp(x, -radius, radius)
end
