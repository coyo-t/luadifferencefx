local bit = require'bit'
local band = bit.band

local clamp = math.clamp
local max = math.max
local floor = math.floor

return function (self)
	local field_1158_g = self.fbuffer_0
	local fbuffer_what = self.fbuffer_1
	local fbuffer_a = self.fbuffer_a
	local fbuffer_b = self.fbuffer_b
	for xx = 0, 15 do
		for yy = 0, 15 do
			local f = 0.0
			for hh = xx - 1, xx + 1 do
				f = f + field_1158_g[(band(hh, 15) + band(yy, 15) * 16) + 1]
			end
			local index = (yy * 16 + xx) + 1
			fbuffer_what[index] = f / 3.3 + fbuffer_a[index] * 0.8
		end
	end

	local random = love.math.random
	for xx = 0, 15 do
		for yy = 0, 15 do
			local i6 = (xx + yy * 16) + 1
			fbuffer_a[i6] = max(fbuffer_a[i6] + fbuffer_b[i6] * 0.05, 0.0)
			if random() < 0.05 then
				fbuffer_b[i6] = 0.5
			else
				fbuffer_b[i6] = fbuffer_b[i6] - 0.1
			end
		end
	end

	self:swapBuffers()
	
	local a = self:getAddress()
	for i8 = 1, 256 do
		local f1 = clamp(field_1158_g[i8], 0, 1) ^ 2
		local i9 = floor(10 + f1 * 21)
		if self.c then
			local i10 = floor(50 + f1 * 64)
			i9 = (i9 * 30 + i10 * 59 + 2805) / 100
		end
		i9 = band(i9, 0xFF)
		local j = (i8-1)*4
		a[j + 0] = i9
		a[j + 1] = i9
		a[j + 2] = i9
		a[j + 3] = 0xFF
	end
end
