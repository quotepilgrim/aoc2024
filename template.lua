local filename = ""

local function get_data(input)
    local data = {}
    local file = io.open(input, "r")

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
        table.insert(data, tokens)
        line = file:read()
    end

    file:close()
    return data
end

local function part_one()
    local data = get_data(filename)
    if data == nil then
        return
    end
    for _, t in ipairs(data) do
        print(table.concat(t, " "))
    end
end

local function part_two()
    local data = get_data(filename)
    if data == nil then
        return
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
        part_one()
    else
        part_two()
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
