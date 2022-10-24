local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)

assert(
	type(futil.version) == "number" and futil.version >= os.time({year = 2022, month = 10, day = 24}),
	"please update futil"
)

action_queues = {
	version = os.time({year = 2022, month = 8, day = 16}),

	modname = modname,
	modpath = modpath,

	log = function(level, messagefmt, ...)
		return minetest.log(level, ("[%s] %s"):format(modname, messagefmt:format(...)))
	end,

	dofile = function(...)
		return dofile(table.concat({modpath, ...}, DIR_DELIM) .. ".lua")
	end,
}

action_queues.dofile("api")
