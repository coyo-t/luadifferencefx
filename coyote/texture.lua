
local t = {}
t.__index = t

function t:__call (name)
	local outs = self.nametable[name]
	if outs == nil then
		local path = ('assets/%s.png'):format(name)
		outs = love.graphics.newImage(path)
		self.nametable[name] = outs
	end
	return outs
end


return setmetatable({
	nametable = {},
}, t)
