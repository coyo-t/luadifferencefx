local shaders = require 'shader'

shaders:create '3d' {
	vertex = [[
	
	]],
	fragment = [[
	
	]]
}

local min = math.min
local max = math.max
local sin = math.sin
local cos = math.cos
local radians = math.rad

local function sico (angle)
	return sin(angle), cos(angle)
end

local function clamp (x, a, b)
	return max(a, min(x, b))
end

local function clampSym (x, radius)
	return clamp(x, -radius, radius)
end

local vertexFormat = {
	{ "VertexPosition", "float", 3 },
	-- { "VertexTexCoord", "float", 2 },
	{ "VertexColor",    "float", 4 },
}

local vertices = {
	{ 1, 0, 0, 1,0,0,1 },
	{ 0, 1, 0, 1,1,0,1 },
	{ 0, 0, 1, 0,1,1,1 },
}

local mesh = love.graphics.newMesh(vertexFormat, vertices, "triangles")


local viewPitch = 0
local viewYaw = 0
local viewRetard = 1/6
local viewDirty = true

local viewMatrix = love.math.newTransform()

local viewForward = { 0, 1, 0 }
local viewUp      = { 0, 0, 1 }
local viewRight   = { 1, 0, 0 }
local viewFlatForward = { 0, 1, 0 }

local function updateView ()
	if not viewDirty then
		return
	end

	local rPitch = radians(viewPitch)
	local rYaw   = radians(viewYaw)

	local pitSin, pitCos = sico(rPitch)
	local yawSin, yawCos = sico(rYaw)

	viewFlatForward[1] = yawSin
	viewFlatForward[2] = yawCos

	viewForward[1] = yawSin
	viewForward[2] = yawCos
	viewRight[1] = -yawCos
	viewRight[2] = yawSin

	viewMatrix:setMatrix(
		viewRight[1],   viewRight[2],   viewRight[3],   0,
		viewForward[1], viewForward[2], viewForward[3], 0,
		0, 0, 1, 0,
		0, 0, 0, 1
	)

end

function love.mousemoved (x, y, dx, dy)
	if not love.mouse.getRelativeMode() then
		return
	end

	if dx == 0 and dy == 0 then
		return
	end

	viewPitch = clampSym(viewPitch - dy * viewRetard, 90)
	viewYaw = viewYaw + dx * viewRetard + 180
	-- yaw(n)
	while viewYaw < 0 do viewYaw = viewYaw + 360 end
	while viewYaw >= 360 do viewYaw = viewYaw - 360 end
	viewYaw = viewYaw - 180

	viewDirty = true
end


function love.draw ()
	updateView()

	-- love.graphics.push()
	-- love.graphics.scale(256, 256)
	-- love.graphics.draw(mesh, 0, 0)
	-- love.graphics.pop()
	
	local ww, wh = love.window.getMode()
	love.graphics.push 'all'
	love.graphics.origin()
	love.graphics.translate(ww*0.5, wh*0.5)
	-- love.graphics.scale(1, -1)

	local sz = 64

	love.graphics.applyTransform(viewMatrix)
	love.graphics.scale(sz)
	love.graphics.draw(mesh, 0, 0)

	love.graphics.pop()

	local txt = ('%.8f %.8f'):format(viewPitch, viewYaw)
	love.graphics.print(txt, 320, 240)
end

function love.load ()
	-- love.graphics.setLineStyle'rough'
	-- love.graphics.setLineWidth(1)
	love.mouse.setRelativeMode(true)
end

function love.keypressed (k)
	if k == 'escape' then
		love.mouse.setRelativeMode(not love.mouse.getRelativeMode())
	end
end
