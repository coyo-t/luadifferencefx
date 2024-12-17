local textures = require'texture'

local shaders = {
	nametable = {},
}
shaders.__index = shaders
shaders = setmetatable(shaders, shaders)

function shaders:create (name)
	return function (shaderCode)
		local outs = love.graphics.newShader(shaderCode)
		self.nametable[name] = outs
		return outs
	end
end

function shaders:__call (name)
	local outs = self.nametable[name]
	if not outs then
		error(('shader with name %s doesnt exist'):format(name))
	end
	return outs
end

local wide = -1
local tall = -1

local fade = 0.9

local invalidate = true
local appsurface
local pevsurface
local pevsurface2


local function draw ()
	local mx, my = love.mouse.getPosition()
	local room = textures 'def'
	
	
	local picWide = room:getWidth()
	local ww, wh = love.window.getMode()

	local ofs = (mx / ww) * (picWide - ww)
	
	love.graphics.push()
	love.graphics.translate(-ofs, 0)

	
	love.graphics.draw(room, 0, 0)
	
	love.graphics.push()
	love.graphics.translate(64, 64)

	local yote = textures 'birthdayyote2'
	local w = yote:getWidth()
	local h = yote:getHeight()
	love.graphics.translate(800, 400)
	love.graphics.rotate(math.rad(math.sin(love.timer.getTime() * math.pi) * 22.5))
	love.graphics.translate(-w*0.5, -h*0.5)
	love.graphics.draw(yote, 0, 0)
	love.graphics.pop()
	
	love.graphics.pop()
	
	
end

local function drawGui ()
	local mx, my = love.mouse.getPosition()
	local text = "WOW!!! %i %i\nmouse (%i %i)"
	love.graphics.print(text:format(wide, tall, mx, my), 320, 240)
end


function love.load ()
	shaders:create 'fin' [[
		uniform Image pev;
	
		vec4 effect (vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
		{
			vec4 app_pix = Texel(tex, texture_coords);
			vec4 pev_pix = Texel(pev, texture_coords);
			return vec4((app_pix.rgb - pev_pix.rgb) * 0.5 + 0.5, 1.0);
		}
	]]

	shaders:create 'fade' [[
		uniform Image appsurface;
	
		vec4 effect (vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
		{
			vec4 fade_pix = Texel(tex, texture_coords);
			vec4 app_pix = Texel(appsurface, texture_coords);
			return vec4(mix(app_pix.rgb, fade_pix.rgb, 0.3), 1.0);
		}
	]]
end

function love.resize (wide, tall)
	invalidate = true
end

function love.draw ()
	local wwide, wtall = love.window.getMode()
	
	if invalidate then
		if appsurface then
			appsurface:release()
			appsurface = nil
		end
	
		if pevsurface then
			pevsurface:release()
			pevsurface2:release()
			pevsurface = nil
			pevsurface2 = nil
		end
		invalidate = false
	end

	if not appsurface then
		appsurface = love.graphics.newCanvas()
	end
	appsurface:renderTo(draw)

	if not pevsurface then
		pevsurface = love.graphics.newCanvas()
		pevsurface2 = love.graphics.newCanvas()

		local function aaa ()
			love.graphics.draw(appsurface, 0, 0)
		end
		
		love.graphics.setBlendMode 'replace'
		pevsurface:renderTo(aaa)
		love.graphics.setBlendMode 'alpha'
	end
	
	pevsurface2:renderTo(function ()
		local fadeShader = shaders 'fade'
		fadeShader:send('appsurface', appsurface)
		love.graphics.setShader(fadeShader)
		love.graphics.draw(pevsurface, 0, 0)
		love.graphics.setShader()
	end)
	pevsurface2, pevsurface = pevsurface, pevsurface2

	local finShader = shaders 'fin'
	finShader:send('pev', pevsurface)
	love.graphics.setShader(finShader)
	love.graphics.draw(appsurface, 0, 0)
	love.graphics.setShader()
	
	appsurface, pevsurface = pevsurface, appsurface

	drawGui()

end
