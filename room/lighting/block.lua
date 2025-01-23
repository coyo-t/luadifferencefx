local Block = {
	lightEmission = 0,
	lightAttenuation = 0,
}
Block.__index = Block

function Block:getLightEmission ()
	return self.lightEmission
end

function Block:getLightAttenuation ()
	return self.lightAttenuation
end

local blocks = {}

local function register (name)
	return function (t)
		t.name = name
		blocks[name] = setmetatable(t, Block)
	end
end


register 'air' {
	lightEmission = 0,
	lightAttenuation = 0,
}

register 'wall' {
	model = {
		texture = { 1, 1 },
	},
	lightEmission = 0,
	lightAttenuation = 0xFF,
}

register 'stone' {
	model = {
		texture = { 1, 0 },
	},
	lightEmission = 0,
	lightAttenuation = 0xFF,
}

register 'dirt' {
	model = {
		texture = { 2, 0 },
	},
	lightEmission = 0,
	lightAttenuation = 0xFF,
}

register 'glowstone' {
	model = {
		texture = { 9, 6 },
	},
	lightEmission = 15,
	lightAttenuation = 0xFF,
}

return blocks
