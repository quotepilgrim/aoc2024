local filename = ""
local list_a = {}
local list_b = {}
local diffs = {}
local sum = 0

local function part1()
	local file = io.open(filename, "r")

	if file == nil then
		love.event.quit()
		return
	end

	local line = file:read()
	while line ~= nil do
		local tokens = {}

		for t in line:gmatch("[^%s]+") do
			table.insert(tokens, tonumber(t))
		end

		table.insert(list_a, tokens[1])
		table.insert(list_b, tokens[2])

		line = file:read()
	end

	file:close()

	table.sort(list_a)
	table.sort(list_b)

	for i = 1, #list_a, 1 do
		table.insert(diffs, math.abs(list_a[i] - list_b[i]))
	end

	for _, v in ipairs(diffs) do
		sum = sum + v
	end

	love.system.setClipboardText(sum)
end

function love.load()
	while #arg > 0 do
		local v = table.remove(arg, 1)
		if v == "-f" then
			filename = table.remove(arg, 1)
		end
	end
	part1()
end

function love.draw()
	love.graphics.print(sum)
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
end
