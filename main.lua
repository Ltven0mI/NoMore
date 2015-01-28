local main = {}
main.loadPriority = 1
main.updatePriority = 1

require("handler")

function main.load()
	print("Main")
end

function main.update(dt)
	--print(dt)
end

handler.addSystem(main, "main")