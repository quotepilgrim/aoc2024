local filename = ""
local answer = 0

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
        for i = 1, #line do
            table.insert(tokens, line:sub(i, i))
        end
        table.insert(data, tokens)
        line = file:read()
    end

    file:close()
    return data
end

local function is_antenna(a)
    return a ~= nil and a ~= "."
end

local function get_type(data, t)
    return data[t[1]][t[2]]
end

local function make_antinodes(a, b, nodes)
    local ay, ax = a[1], a[2]
    local by, bx = b[1], b[2]
    local dx = ax - bx
    local dy = ay - by
    local nx = ax - dx
    local ny = ay - dy

    local dx2 = bx - ax
    local dy2 = by - ay
    local nx2 = ax - dx2
    local ny2 = ay - dy2

    local n1_exists = true
    local n2_exists = true

    if ny > #nodes or ny < 1 or nx > #nodes[ny] or nx < 1 then
        n1_exists = false
    end
    if ny2 > #nodes or ny2 < 1 or nx2 > #nodes[ny2] or nx2 < 1 then
        n2_exists = false
    end
    if n1_exists then
        nodes[ny][nx] = true
    end
    if n2_exists then
        nodes[ny2][nx2] = true
    end
end

local function part_one()
    local data = get_data(filename)
    if data == nil then
        return
    end
    local antennae = {}
    local antinodes = {}
    for i, t in ipairs(data) do
        antinodes[i] = {}
        for j, v in ipairs(t) do
            if is_antenna(v) then
                table.insert(antennae, { i, j })
            end
            antinodes[i][j] = false
        end
    end
    local i = 1
    while i < #antennae + 1 do
        for s = i, #antennae do
            if get_type(data, antennae[i]) == get_type(data, antennae[s]) then
                make_antinodes(antennae[i], antennae[s], antinodes)
            end
        end
        i = i + 1
    end
    for y = 1, #antinodes do
        for x = 1, #antinodes[1] do
            if antinodes[y][x] then
                io.write("#")
                answer = answer + 1
            else
                io.write(".")
            end
        end
        io.write("\n")
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

    love.system.setClipboardText(answer)
end

function love.draw()
    love.graphics.print(answer, 12, 12)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
