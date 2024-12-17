local textures = {}

local function tex (name)
	local outs = textures[name]
	if outs == nil then
		local path = ('assets/%s.png'):format(name)
		outs = love.graphics.newImage(path)
		textures[name] = outs
	end
	return outs
end

local wide = -1
local tall = -1


local appsurface = nil
local pevsurface = nil

local function createScreenBuffer ()
	return love.graphics.newCanvas(wide, tall)
end

local function draw ()
	local mx, my = love.mouse.getPosition()
	local text = "WOW!!! %i %i\nmouse (%i %i)"
	local room = tex 'def'
	

	local picWide = room:getWidth()

	local ofs = (mx / wide) * (picWide - wide)

	love.graphics.push()
	love.graphics.translate(-ofs, 0)
	love.graphics.draw(room, 0, 0)
	love.graphics.pop()
	
	
	love.graphics.print(text:format(wide, tall, mx, my), 320, 240)
end

local function tryRenderAppsurface ()
	if not appsurface then
		appsurface = createScreenBuffer()
	end
	appsurface:renderTo(draw)
end

function love.draw ()
	local wwide, wtall = love.window.getMode()
	if wwide ~= wide or wtall ~= tall then
		if appsurface then
			appsurface:release()
			appsurface = nil
		end
		wide = wwide
		tall = wtall
	end
	
	tryRenderAppsurface()

	if not pevsurface then
		pevsurface = createScreenBuffer()
		pevsurface:renderTo(function ()
			love.graphics.setBlendMode 'replace'
			love.graphics.draw(appsurface, 0, 0)
			love.graphics.setBlendMode 'alpha'
		end)
	else
		pevsurface:renderTo(function ()
			
		end)
	end
	
	love.graphics.draw(appsurface, 0, 0)


end
