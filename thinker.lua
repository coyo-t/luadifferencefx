
local t = {
	callback = false,
	thinkTime = 1,
	nextThink = -1,
}
t.__index = t

function t:step ()
	local t = love.timer.getTime()
	if t >= self.nextThink then
		local cb = self.callback
		if cb then
			cb()
		end
		self.nextThink = t + self.thinkTime
		return true
	end
	return false
end

return function (tps, callback)
	return setmetatable({
		thinkTime = 1.0 / tps,
		callback = callback,
	}, t)
end
