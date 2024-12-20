local t = {
	nametable = {},
	toCompile = {},
	init = false,
}

local function createShader (args)
	local ty = type(args)
	if ty == 'string' then
		return love.graphics.newShader(args)
	elseif ty == 'table' then
		return love.graphics.newShader(args.fragment, args.vertex)
	end
	error(('Expected string or table for shader, got %s'):format(ty))
end

function t:_spinup ()
	if t.init then
		return
	end
	for k, v in pairs(t.toCompile) do
		t.nametable[k] = createShader(v)
	end
	t.toCompile = nil
	t.init = true
end

function t:create (name)
	return function (shaderCode)
		if not t.init then
			t.toCompile[name] = shaderCode
		else
			t.nametable[name] = createShader(shaderCode)
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
