handler = {}
system = {}

-- Callbacks --
function love.load(args)
	handler.getSystems("/code/systems")

	local toCall = {}
	local max = 0
	for k, v in pairs(system) do
		local pri = v.loadPriority
		if pri and type(pri) == "number" then if toCall[pri] then if pri+1 > max then max = pri+1 end else if pri > max then max = pri end end table.insert(toCall, pri, v) end	end
	for i=1, max do
		if toCall[i].load then toCall[i].load(args) end
	end
end

function love.update(dt)
	local toCall = {}
	local max = 0
	for k, v in pairs(system) do
		local pri = v.updatePriority
		if pri and type(pri) == "number" then if toCall[pri] then if pri+1 > max then max = pri+1 end else if pri > max then max = pri end end table.insert(toCall, pri, v) end
	end
	for i=1, max do
		if toCall[i].update then toCall[i].update(dt) end
	end
end

-- Functions --
function handler.addSystem(sys,key)
	if key and type(key) == "string" and sys and type(sys) == "table" then
		if not system[key] then
			system[key] = sys
			print("[HANDLER] System with key '"..key.."' added to systems.")
		else
			print("[HANDLER] System with key '"..key.."' already exists!")
		end
	end
end

function handler.getSystems(dir)
	if dir and love.filesystem.isDirectory(dir) then
		local items = love.filesystem.getDirectoryItems(dir)
		for k, item in pairs(items) do 
			local key = item:gsub(".lua", "")
			if key and key ~= "" then
				handler.addSystem(require(dir.."/"..key), key)
			end
		end
	end
end

function spairs(t, order)
	-- collect the keys
	local keys = {}
	for k in pairs(t) do keys[#keys+1] = k end

	-- if order function given, sort by it by passing the table and keys a, b,
	-- otherwise just sort the keys 
	if order then
		table.sort(keys, function(a,b) return order(t, a, b) end)
	else
		table.sort(keys)
	end

	-- return the iterator function
	local i = 0
	return function()
		i = i + 1
		if keys[i] then
			return keys[i], t[keys[i]].loadPriority
		end
	end
end