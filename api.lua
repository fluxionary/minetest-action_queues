local Deque = futil.Deque

function action_queues.create_serverstep_queue(params)
	local deque = Deque()

	if params.us_per_step then
		assert(params.us_per_step > 0)
		local penalty = 0
		minetest.register_globalstep(function(dtime)
			local us_per_step = params.us_per_step
			local get_us_time = minetest.get_us_time
			local start = get_us_time()
			local elapsed = 0
			local actual_us_per_step = us_per_step - penalty
			if actual_us_per_step <= 0 then
				penalty = penalty - us_per_step
				return
			end

			local f = deque:pop_front()
			while f and elapsed < actual_us_per_step do
				if f(params, dtime, elapsed) then
					break
				end
				f = deque:pop_front()
				elapsed = get_us_time() - start
			end

			-- we didn't run this, so put it back
			if f then
				deque:push_front(f)
			end
			penalty = math.max(0, elapsed - actual_us_per_step)
		end)
	elseif params.every_n_steps and params.every_n_steps > 0 then
		local steps = 0
		minetest.register_globalstep(function(dtime)
			steps = steps + 1

			if steps < params.every_n_steps then
				return
			end

			for i = 1, math.min(params.num_per_step, deque:size()) do
				if deque:pop_front()(params, dtime, i) then
					break
				end
			end

			steps = 0
		end)
	elseif params.every_n_seconds and params.every_n_seconds > 0 then
		local seconds = 0
		minetest.register_globalstep(function(dtime)
			seconds = dtime + 1

			if seconds < params.every_n_seconds then
				return
			end

			for i = 1, math.min(params.num_per_step, deque:size()) do
				if deque:pop_front()(params, dtime, i) then
					break
				end
			end

			seconds = 0
		end)
	elseif params.num_per_step then
		minetest.register_globalstep(function(dtime)
			for i = 1, math.min(params.num_per_step, deque:size()) do
				if deque:pop_front()(params, dtime, i) then
					break
				end
			end
		end)
	else
		error(string.format("invalid action queue definition %s", dump(params)))
	end

	return deque
end

-- backwards compatibility
action_queues.api = {
	create_serverstep_queue = action_queues.create_serverstep_queue,
}
