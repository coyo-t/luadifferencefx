local textures = require'coyote.texture'

local blocks = require'room.lighting.block'

local bit = require'bit'
local band = bit.band
local floor = math.floor
local exp = math.exp
local sin = math.sin
local pi = math.pi

local world = require('room.lighting.world')(64, 64)

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
local globalMouseX, globalMouseY = 0, 0

function love.wheelmoved (wx, wy)
	if wy ~= 0 then
		local sens = 1.0 / 8
		view.zoom = view.zoom * exp(wy * sens)
	end
end

function love.mousereleased (x, y, button)
	if button == 3 and releaseMouse() then
		mx,my = love.mouse.getPosition()
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
		mx = mx + dx
		my = my + dy
		return
	end
	mx = x
	my = y
end

function love.update ()
	if not mouseGrabbed then
		local mx, my = love.mouse.getPosition()
		local ww, wh = love.graphics.getDimensions()
		local zoom = view.zoom
		local rcpZoom = 1.0 / zoom
		globalMouseX = (mx-ww*0.5) * rcpZoom + view.x
		globalMouseY = (my-wh*0.5) * rcpZoom + view.y
	end
end

local function drawGrid ()
	local grid = world:getGrid()
	local wide, tall = world:getSize()
	for i = 1, world:getCount() do
		local x = (i - 1) % wide
		local y = floor((i - 1) / wide)
		local sample = grid[i]
		if sample == 'air' then
			goto continue
		end
		love.graphics.rectangle('fill', x, y, 1, 1)
		::continue::
	end
	love.graphics.setLineWidth(1.0 / view.zoom)
	love.graphics.setColor(1, 1, 1, 1.0)
	local ww, wh = world:getSize()
	love.graphics.rectangle('line', 0, 0, ww, wh)
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
	
	local gx, gy = floor(globalMouseX), floor(globalMouseY)
	if not mouseGrabbed then
		if love.mouse.isDown(1) then
			world:setAt(gx, gy, 'air')
		elseif love.mouse.isDown(2) then
			world:setAt(gx, gy, 'stone')
		end
	end


	drawGrid()
	do
		local t = love.timer.getTime()
		local pulse = (sin(t * pi * 4) * 0.5 + 0.5) * 0.05
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
