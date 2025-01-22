local shaders = require 'coyote.shader'
local camera = require 'coyote.camera'

shaders:create '3d' {
	vertex = [[
	
	]],
	fragment = [[
	
	]]
}

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

local viewRetard = 1/6



function love.mousemoved (x, y, dx, dy)
	if not love.mouse.getRelativeMode() then
		return
	end

	camera:turn(dy * viewRetard, dx * viewRetard)
end


function love.draw ()
	camera:update()

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

	love.graphics.applyTransform(camera.viewMatrix)
	love.graphics.scale(sz)
	love.graphics.draw(mesh, 0, 0)

	love.graphics.pop()

	local txt = ('%.8f %.8f'):format(camera.pitch, camera.yaw)
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
