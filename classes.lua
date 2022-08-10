local deque_class = action_queues.util.class()

-- inspired by https://www.lua.org/pil/11.4.html

function deque_class:_new(def)
	self._a = 0
	self._z = -1
	self._m = def and def.max_size
end

function deque_class:size()
	return self._z - self._a + 1
end

function deque_class:push_front(value)
	local max_size = self._m
	if max_size and (self._z - self._a + 1) >= max_size then
		return false
	end
	local a = self._a - 1
	self._a = a
	self[a] = value
	return true
end

function deque_class:push_back(value)
	local max_size = self._m
	if max_size and (self._z - self._a + 1) >= max_size then
		return false
	end
	local z = self._z + 1
	self._z = z
	self[z] = value
	return true
end

function deque_class:pop_front()
	local a = self._a
	if a > self._z then
		return nil
	end
	local value = self[a]
	self[a] = nil
	self._a = a + 1
	return value
end

function deque_class:pop_back()
	local z = self._z
	if self._a > z then
		return nil
	end
	local value = self[z]
	self[z] = nil
	self._z = z + 1
	return value
end

action_queues.deque_class = deque_class
