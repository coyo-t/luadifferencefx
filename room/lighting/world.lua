local bit = require'bit'
local band = bit.band
local floor = math.floor

local World = {}
World.__index = World

function World:getCount ()
	return self.count
end

function World:getSize ()
	return self.wide, self.tall
end

function World:getGrid ()
	return self.grid
end

function World:setAt (x, y, value)
	local wide, tall = self:getSize()
	if 0 <= x and x < wide and 0 <= y and y < tall then
		local addr = (y * wide + x) + 1
		self.grid[addr] = floor(band(value, 0xF))
	end
end

local function createWorld (wide, tall)
	local count = wide * tall
	local grid = {}
	for i = 1, count do
		grid[i] = floor(love.math.random(0, 15))
	end
	return setmetatable({
		grid = grid,
		wide = wide,
		tall = tall,
		count = count,
	}, World)
end

return createWorld
