
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

local pevwide = -1
local pevtall = -1

function love.draw ()
	local room = tex 'def'

	local wide, tall = love.window.getMode()

	local text = "WOW!!! %i %i"

	love.graphics.draw(room, 0, 0)
	love.graphics.print(text:format(wide, tall), 320, 240)
end
