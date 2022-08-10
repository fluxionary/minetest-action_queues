local deque_class = action_queues.deque_class

local api = {}

function api.create_serverstep_queue(params)
	local deque = deque_class()

	if params.us_per_step then
		minetest.register_globalstep(function()
			local get_us_time = minetest.get_us_time
			local start = get_us_time()
			local now = start
			local f = deque:pop_front()
			local us_per_step = params.us_per_step

			while f and (now - start) < us_per_step do
				f(now)
				f = deque:pop_front()
				now = get_us_time()
			end
		end)

	elseif params.every_n_steps then
		local steps = 0
		minetest.register_globalstep(function()
			steps = steps + 1

			if steps < params.every_n_steps then
				return
			end

			for _ = 1, math.min(params.num_per_step, deque:size()) do
				deque:pop_front()(steps)
			end

			steps = 0
		end)

	elseif params.every_n_seconds then
		local seconds = 0
		minetest.register_globalstep(function(dtime)
			seconds = dtime + 1

			if seconds < params.every_n_seconds then
				return
			end

			for _ = 1, math.min(params.num_per_step, deque:size()) do
				deque:pop_front()(seconds)
			end

			seconds = 0
		end)

	else
		minetest.register_globalstep(function(dtime)
			for _ = 1, math.min(params.num_per_step, deque:size()) do
				deque:pop_front()(dtime)
			end
		end)
	end

	return deque
end

action_queues.api = api
