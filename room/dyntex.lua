require'coyote.mth'

local ffi = require'ffi'

local bit = require'bit'
local band = bit.band

local clamp = math.clamp
local max = math.max

local math = math
local floor = math.floor

local function createFloatBuffer (size)
	local outs = {}
	for i = 1, size do
		outs[i] = 0.0
	end
	return outs
end

local pic = {
	wide = 16,
	tall = 16,
	-- placeholders
	count = 0,
	imageData = false,
	grid = false,

	fbuffer_0 = createFloatBuffer(256),
	fbuffer_1 = createFloatBuffer(256),
	fbuffer_a = createFloatBuffer(256),
	fbuffer_b = createFloatBuffer(256),
	c = false,
}

function pic:getAddress ()
	return ffi.cast('uint8_t*', self.imageData:getFFIPointer())
end

function pic:createImage ()
	return love.graphics.newImage(self.imageData)
end

function pic:swapBuffers ()
	self.fbuffer_1, self.fbuffer_0 = self.fbuffer_0, self.fbuffer_1
end

function pic:step ()
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

local displayPic
local displayGrid

function love.load ()
	love.graphics.setDefaultFilter'nearest'

	local pic_w = pic.wide
	local pic_h = pic.tall

	local p = love.image.newImageData(pic_w, pic_h)
	pic.imageData = p

	displayPic = pic:createImage()
	displayGrid = love.graphics.newSpriteBatch(displayPic)

	for xx = 1, 3 do
		for yy = 1, 3 do
			displayGrid:add((xx-1)*16, (yy-1)*16)
		end
	end
end

function love.keypressed (k)
	if k == 'space' then
		pic.c = not pic.c
	end
end

local lastmod = -1
local displayMessage = ''
local thinker = require'thinker'(
	20,
	function (self)
		local path = 'ticker.lua'
		local f = love.filesystem.getInfo(path)
		if f.modtime ~= lastmod then
			local status, res = pcall(dofile, path)
			if status then
				pic.step = res
			else
				displayMessage = tostring(self.ticksExecuted)..' '..tostring(res)
			end
			lastmod = f.modtime
		end
		print(tostring(pic))
		local status, res = pcall(pic.step, pic)
		if status then
			displayPic:replacePixels(pic.imageData)
		else
			displayMessage = tostring(self.ticksExecuted)..' '..tostring(res)
		end
	end
)

function love.update ()
	thinker:step()
end

function love.draw ()
	love.graphics.push()
	love.graphics.scale(16)
	love.graphics.draw(displayGrid)
	love.graphics.pop()
	love.graphics.print(displayMessage, 32, 32)
	-- love.graphics.draw(displayPic, 0, 0, 0.0, 16.0)
end
