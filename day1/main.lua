local filename = ""
local list_a = {}
local list_b = {}
local diffs = {}
local scores = {}
local result = 0

local function make_lists()
    local file = io.open(filename, "r")

    if file == nil then
        love.event.quit()
        return
    end

    local line = file:read()
    while line ~= nil do
        local tokens = {}

        for t in line:gmatch("[^%s]+") do
            table.insert(tokens, t)
        end

        table.insert(list_a, tokens[1])
        table.insert(list_b, tokens[2])

        line = file:read()
    end

    file:close()
end

local function part1()
    make_lists()

    table.sort(list_a)
    table.sort(list_b)

    for i = 1, #list_a, 1 do
        table.insert(diffs, math.abs(list_a[i] - list_b[i]))
    end

    for _, v in ipairs(diffs) do
        result = result + v
    end
end

local function part2()
    make_lists()
    for _, v in ipairs(list_a) do
        local count = 0
        for _, w in ipairs(list_b) do
            if v == w then
                count = count + 1
            end
        end
        table.insert(scores, count * v)
    end

    for _, v in ipairs(scores) do
        result = result + v
    end
end

function love.load()
    local part = 1

    while #arg > 0 do
        local v = table.remove(arg, 1)
        if v == "-f" then
            filename = table.remove(arg, 1)
        end
        if v == "-p2" then
            part = 2
        end
    end

    if part == 1 then
        part1()
    else
        part2()
    end

    love.system.setClipboardText(result)
end

function love.draw()
    love.graphics.print(result, 12, 12)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
