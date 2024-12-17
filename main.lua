
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

local appsurface

local function draw ()
	local text = "WOW!!! %i %i"
	
	love.graphics.draw(room, 0, 0)
	love.graphics.print(text:format(wide, tall), 320, 240)
end

function love.draw ()
	local room = tex 'def'

	do
		local wwide, wtall = love.window.getMode()
	
		if wwide ~= wide or wtall ~= tall then
			if appsurface then
				appsurface:release()
				appsurface = nil
			end
			wide = wwide
			tall = wtall
		end
	end

	if not appsurface then
		appsurface = love.graphics.newCanvas(wide, tall)
	end

	if appsurface then
		appsurface:renderTo(draw)
		love.graphics.draw(appsurface, 0, 0)
	end

end
