handler = {}
system = {}
library = {}

-- Callbacks --
function love.load(args)
	handler.getLibraries("/code/libraries")
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

function love.draw()
	local toCall = {}
	local max = 0
	for k, v in pairs(system) do
		local pri = v.drawworldPriority
		if pri and type(pri) == "number" then if toCall[pri] then if pri+1 > max then max = pri+1 end else if pri > max then max = pri end end table.insert(toCall, pri, v) end
	end
	for i=1, max do
		if toCall[i].drawworld then toCall[i].drawworld() end
	end

	toCall = {}
	max = 0
	for k, v in pairs(system) do
		local pri = v.drawscreenPriority
		if pri and type(pri) == "number" then if toCall[pri] then if pri+1 > max then max = pri+1 end else if pri > max then max = pri end end table.insert(toCall, pri, v) end
	end
	for i=1, max do
		if toCall[i].drawscreen then toCall[i].drawscreen() end
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
			if love.filesystem.isFile(dir.."/"..item) then
				local key = item:gsub(".lua", "")
				if key and key ~= "" then
					handler.addSystem(require(dir.."/"..key), key)
				end
			elseif love.filesystem.isDirectory(dir.."/"..item) and item ~= "blacklist" then
				handler.getSystems(dir.."/"..item)
			end
		end
	end
end

function handler.addLibrary(lib,key)
	if key and type(key) == "string" and lib and type(lib) == "table" then
		if not library[key] then
			library[key] = lib
			print("[HANDLER] Library with key '"..key.."' added to libraries.")
		else
			print("[HANDLER] Library with key '"..key.."' already exists!")
		end
	end
end

function handler.getLibraries(dir)
	if dir and love.filesystem.isDirectory(dir) then
		local items = love.filesystem.getDirectoryItems(dir)
		for k, item in pairs(items) do 
			if love.filesystem.isFile(dir.."/"..item) then
				local key = item:gsub(".lua", "")
				if key and key ~= "" then
					handler.addLibrary(require(dir.."/"..key), key)
				end
			elseif love.filesystem.isDirectory(dir.."/"..item) and item ~= "blacklist" then
				handler.getLibraries(dir.."/"..item)
			end
		end
	end
end