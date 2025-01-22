local ffi = require'ffi'

local bit = require'bit'
local band = bit.band

local floor = math.floor

local pic = {
	wide = 32,
	tall = 32,
	-- placeholders
	count = 0,
	imageData = false,
	grid = false,
}

function pic:createImage ()
	return love.graphics.newImage(self.imageData)
end

function pic:setPixelI (i, r, g, b, a)
	if 0 <= i and i < self.count then
		local grid = self.grid
		local j = i * 4
		grid[j] = band(r, 0xFF)
		grid[j+1] = band(g, 0xFF)
		grid[j+2] = band(b, 0xFF)
		grid[j+3] = band(a, 0xFF)
	end
end

local display

function love.load ()
	love.graphics.setDefaultFilter('nearest', 'nearest')

	local pic_w = pic.wide
	local pic_h = pic.tall

	local p = love.image.newImageData(pic_w, pic_h)
	pic.imageData = p
	pic.grid = ffi.cast('uint8_t*', p:getFFIPointer())
	pic.count = pic_w * pic_h
	
	local count = pic.count
	local picptr = pic.grid
	for i = 1, count do
		local j = i - 1
		local xx = j % pic_w
		local yy = floor(j / pic_w)
		xx = floor((xx / (pic_w-1)) * 0xFF)
		yy = floor((yy / (pic_h-1)) * 0xFF)
		local luma = bit.bxor(xx, yy)

		pic:setPixelI(j, luma, luma, luma, 0xFF)
	end
	display = pic:createImage()
end

function love.update ()

end

function love.draw ()
	love.graphics.draw(display, 0, 0, 0.0, 16.0)
end
