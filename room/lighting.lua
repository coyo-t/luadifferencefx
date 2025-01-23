
local bit = require'bit'
local floor = math.floor
local exp = math.exp
local sin = math.sin
local pi = math.pi

local gridSize = 16
local gridCount = gridSize ^ 2
local grid = {}

for i = 1, gridCount do
	grid[i] = floor(love.math.random(0, 15))
end

local view = {
	x = 0,
	y = 0,
	zoom = 16.0,

}

local mouseGrabbed = false

local function grabMouse ()
	if mouseGrabbed then
		return false
	end
	mouseGrabbed = true
	love.mouse.setRelativeMode(true)
	return true
end

local function releaseMouse ()
	if not mouseGrabbed then
		return false
	end
	mouseGrabbed = false
	love.mouse.setRelativeMode(false)
	return true
end

function love.load ()

end

local mx, my = 0, 0

function love.wheelmoved (wx, wy)
	if wy ~= 0 then
		local sens = 1.0 / 8
		view.zoom = view.zoom * exp(wy * sens)
	end
end

function love.mousereleased (x, y, button)
	if button == 3 and releaseMouse() then
		return
	end
	
	if mouseGrabbed then
		return
	end
end

function love.mousepressed (x, y, button)
	if button == 3 and grabMouse() then
		return
	end
	
	if mouseGrabbed then
		return
	end
end

function love.mousemoved (x, y, dx, dy)
	if mouseGrabbed then
		local rcp = 1.0 / view.zoom
		view.x = view.x - dx * rcp
		view.y = view.y - dy * rcp
	end
end

function love.update ()

end

local function drawGrid ()
	for i = 1, gridCount do
		local sample = grid[i]
		local x = (i - 1) % gridSize
		local y = floor((i - 1) / gridSize)
		local luma = sample / 15
		love.graphics.setColor(luma, luma, luma, 1.0)
		love.graphics.rectangle('fill', x, y, 1, 1)
	end
end

function love.draw ()
	love.graphics.push()
	local vw, vh = love.graphics.getDimensions()
	local hw = vw * 0.5
	local hh = vh * 0.5
	local vzoom = view.zoom
	local rcpzoom = 1.0 / vzoom
	-- love.graphics.translate(hw, hh)
	love.graphics.scale(vzoom)
	-- love.graphics.translate(-hw, -hh)
	love.graphics.translate(-view.x+hw*rcpzoom, -view.y+hh*rcpzoom)
	drawGrid()

	do
		local t = love.timer.getTime()
		local pulse = (sin(t * pi * 4) * 0.5 + 0.5) * 0.05
		local mx, my = love.mouse.getPosition()
		local gx, gy = love.graphics.inverseTransformPoint(mx, my)
		gx = floor(gx)
		gy = floor(gy)
		love.graphics.setColor(1, 1, 0, 1.0)
		local sz = pulse * 2
		love.graphics.setLineWidth(1.0 / view.zoom)
		love.graphics.rectangle('line', gx-pulse, gy-pulse, 1+sz, 1+sz)
		love.graphics.setColor(1, 1, 0, 1.0)
	end

	love.graphics.pop()
	
	local fmt = '%.8f\n%.8f'
	love.graphics.setColor(1, 1, 0, 1.0)
	love.graphics.print(fmt:format(view.x, view.y), 32, 32)
	love.graphics.setColor(1, 1, 1, 1.0)
end
