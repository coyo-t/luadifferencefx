require 'mth'

local radians = math.rad
local clampSym = math.clampSym
local sico = math.sico
local newTransform = love.math.newTransform

local camera = {
	pitch = 0,
	yaw = 0,
	dirty = true,

	viewMatrix = newTransform(),

	forward = { 0, 1, 0 },
	up      = { 0, 0, 1 },
	right   = { 1, 0, 0 },
	flatForward = { 0, 1, 0 },
}

function camera:turn (deltaPitch, deltaYaw)
	local dirty = false
	if deltaPitch ~= 0 then
		self.pitch = clampSym(self.pitch + deltaPitch, 90)
		dirty = true
	end

	if deltaYaw ~= 0 then
		local yaw = self.yaw
		yaw = yaw + deltaYaw + 180
		-- yaw(n)
		while yaw < 0 do yaw = yaw + 360 end
		while yaw >= 360 do yaw = yaw - 360 end
		yaw = yaw - 180
		self.yaw = yaw
		dirty = true
	end

	self.dirty = self.dirty or dirty
end

function camera:update ()
	if not self.dirty then
		return
	end

	local rPitch = radians(self.pitch)
	local rYaw   = radians(self.yaw)

	local pitSin, pitCos = sico(rPitch)
	local yawSin, yawCos = sico(rYaw)

	local viewFlatForward = self.flatForward
	local viewForward = self.forward
	local viewRight = self.right
	
	viewFlatForward[1] = yawSin
	viewFlatForward[2] = yawCos
	
	viewForward[1] = yawSin
	viewForward[2] = yawCos
	viewRight[1] = -yawCos
	viewRight[2] = yawSin
	
	self.viewMatrix:setMatrix(
		viewRight[1],   viewRight[2],   viewRight[3],   0,
		viewForward[1], viewForward[2], viewForward[3], 0,
		0, 0, 1, 0,
		0, 0, 0, 1
	)
end

return camera
