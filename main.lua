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

local finShader

local wide = -1
local tall = -1

local fade = 0.9

local appsurface
local pevsurface
local pevsurface2

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

function love.load ()
	finShader = love.graphics.newShader [[
		uniform Image pev;

		vec4 effect (vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
		{
			vec4 app_pix = Texel(tex, texture_coords);
			vec4 pev_pix = Texel(pev, texture_coords);
			return vec4((app_pix.rgb - pev_pix.rgb) * 0.5 + 0.5, 1.0);
		}
	]]
end

function love.draw ()
	local wwide, wtall = love.window.getMode()
	if wwide ~= wide or wtall ~= tall then
		if appsurface then
			appsurface:release()
			if pevsurface then
				pevsurface:release()
				pevsurface = nil
				pevsurface2:release()
				pevsurface2 = nil
			end
			appsurface = nil

		end
		wide = wwide
		tall = wtall
	end
	
	tryRenderAppsurface()

	if not pevsurface then
		pevsurface = createScreenBuffer()
		pevsurface2 = createScreenBuffer()
		
		local function aaa ()
			love.graphics.draw(appsurface, 0, 0)
		end
		
		love.graphics.setBlendMode 'replace'
		pevsurface:renderTo(aaa)
		pevsurface2:renderTo(aaa)
		love.graphics.setBlendMode 'alpha'
	end
	
	pevsurface:renderTo(function ()
		love.graphics.draw(appsurface, 0, 0)
		love.graphics.setColor(1, 1, 1, fade)
		love.graphics.draw(pevsurface2, 0, 0)
		love.graphics.setColor(1, 1, 1, 1)
	end)

	love.graphics.setShader(finShader)
	finShader:send('pev', pevsurface)
	love.graphics.draw(appsurface, 0, 0)
	love.graphics.setShader()
	
	pevsurface, pevsurface2 = pevsurface2, pevsurface

end
