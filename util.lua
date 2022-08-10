local util = {}

function util.class(super)
    local class = {}
	class.__index = class

	if super then
		setmetatable(class, {__index = super})
	end

    function class:__call(...)
        local obj = setmetatable({}, class)
        if obj._new then
            obj:_new(...)
        end
        return obj
    end

    return class
end

action_queues.util = util
