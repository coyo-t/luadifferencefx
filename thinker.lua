
local t = {
	callback = false,
	thinkTime = 1,
	nextThink = -1,
	ticksExecuted = 0,
}
t.__index = t

function t:step ()
	local t = love.timer.getTime()
	if t >= self.nextThink then
		local cb = self.callback
		if cb then
			cb(self)
		end
		self.nextThink = t + self.thinkTime
		self.ticksExecuted = self.ticksExecuted + 1
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
