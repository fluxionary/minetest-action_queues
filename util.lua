local util = {}

function util.class(super)
    local class = {}
	class.__index = class

	local meta = {
		__call = function(...)
	        local obj = setmetatable({}, class)
	        if obj._init then
	            obj:_init(...)
	        end
	        return obj
	    end
	}

	if super then
		meta.__index = super
	end

	setmetatable(class, meta)

    return class
end

action_queues.util = util
