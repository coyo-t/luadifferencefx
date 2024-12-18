local min = math.min
local max = math.max

local function clamp (x, a, b)
	return max(a, min(x, b))
end

local function clampSym (x, radius)
	return clamp(x, -radius, radius)
end

local viewPitch = 0
local viewYaw = 0
local viewRetard = 1/6

function love.mousemoved (x, y, dx, dy)
	viewPitch = clampSym(viewPitch + dy * viewRetard, 90)
	
end

function love.load ()
	
	love.mouse.setRelativeMode(true)

end

function love.update (dt)
	
end

function love.draw ()

end
