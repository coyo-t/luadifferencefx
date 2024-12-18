local min = math.min
local max = math.max

local function clamp (x, a, b)
	return max(a, min(x, b))
end

local function clampSym (x, radius)
	return clamp(x, -radius, radius)
end

local vertexFormat = {
	{"VertexPosition", "float", 3},
	{"VertexTexCoord", "float", 2},
}

local vertices = {
	{-0.5, -0.5, -0.5, 0, 0},
	{ 0.5, -0.5, -0.5, 1, 1},
	{ 0.5,  0.5, -0.5, 0, 1},

}

local mesh = love.graphics.newMesh(vertexFormat, vertices, "triangles")


local viewPitch = 0
local viewYaw = 0
local viewRetard = 1/6

function love.mousemoved (x, y, dx, dy)
	if not love.mouse.getRelativeMode() then
		return
	end

	viewPitch = clampSym(viewPitch - dy * viewRetard, 90)
	viewYaw = viewYaw + dx * viewRetard + 180
	-- yaw(n)
	while viewYaw < 0 do viewYaw = viewYaw + 360 end
	while viewYaw >= 360 do viewYaw = viewYaw - 360 end
	viewYaw = viewYaw - 180
end

function love.keypressed (k)
	if k == 'escape' then
		love.mouse.setRelativeMode(not love.mouse.getRelativeMode())
	end
end

function love.load ()
	
	love.mouse.setRelativeMode(true)

end

function love.update (dt)
	
end

function love.draw ()
	love.graphics.push()
	love.graphics.scale(256, 256)
	love.graphics.draw(mesh, 0, 0)
	love.graphics.pop()

	local txt = ('%.8f %.8f'):format(viewPitch, viewYaw)
	love.graphics.print(txt, 320, 240)
end
