local t = {
	nametable = {},
	toCompile = {},
	init = false,
}

function t:_spinup ()
	if t.init then
		return
	end
	for k, v in pairs(t.toCompile) do
		t.nametable[k] = love.graphics.newShader(v)
	end
	t.toCompile = nil
	t.init = true
end

function t:create (name)
	return function (shaderCode)
		if not t.init then
			t.toCompile[name] = shaderCode
		else
			local outs = love.graphics.newShader(shaderCode)
			t.nametable[name] = outs
		end
	end
end

function t:__call (name)
	local outs = t.nametable[name]
	if not outs then
		error(('shader with name %s doesnt exist'):format(name))
	end
	return outs
end

t.__index = t
t = setmetatable(t, t)

return t
