local bit = require'bit'
local ffi = require'ffi'
local pic_w = 32
local pic_h = 32
local pic = love.image.newImageData(pic_w, pic_h)

local display

function love.load ()
	love.graphics.setDefaultFilter('nearest', 'nearest')
	
	local count = pic_w * pic_h
	local floor = math.floor
	local picptr = ffi.cast('uint8_t*', pic:getFFIPointer())
	for i = 1, count do
		local j = i - 1
		local xx = j % pic_w
		local yy = floor(j / pic_w)
		xx = floor((xx / (pic_w-1)) * 0xFF)
		yy = floor((yy / (pic_h-1)) * 0xFF)
		local luma = bit.bxor(xx, yy)
		
		local addr = j * 4
		picptr[addr] = luma
		picptr[addr+1] = luma
		picptr[addr+2] = luma
		picptr[addr+3] = 0xFF
	end
	display = love.graphics.newImage(pic)
	-- display:setFilter('nearest', 'nearest')

end

function love.update ()

end

function love.draw ()
	love.graphics.draw(display, 0, 0, 0.0, 16.0)
end
