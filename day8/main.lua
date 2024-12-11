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

local function make_antinode(a, b, nodes)
    local ax, bx = a[2], b[2]
    local ay, by = a[1], b[1]
    local dx = bx - ax
    local dy = by - ay

    if ax == bx and ay == by then
        return
    end

    local nx = ax - dx
    local ny = ay - dy

    if nodes[ny] ~= nil then
        if nodes[ny][nx] ~= nil then
            nodes[ny][nx] = true
        end
    end
end

local function make_antinodes(a, b, nodes)
    local ax, bx = a[2], b[2]
    local ay, by = a[1], b[1]
    local dx = bx - ax
    local dy = by - ay

    if ax == bx and ay == by then
        nodes[ay][ax] = true
        return
    end

    local cx, cy = dx, dy

    local inbounds = true
    while inbounds do
        local nx = ax - dx
        local ny = ay - dy
        if nodes[ny] ~= nil then
            if nodes[ny][nx] ~= nil then
                nodes[ny][nx] = true
            else
                inbounds = false
            end
        else
            inbounds = false
        end
        dx = dx + cx
        dy = dy + cy
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
    for a = 1, #antennae do
        for b = 1, #antennae do
            if get_type(data, antennae[a]) == get_type(data, antennae[b]) then
                make_antinode(antennae[a], antennae[b], antinodes)
            end
        end
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
    for a = 1, #antennae do
        for b = 1, #antennae do
            if get_type(data, antennae[a]) == get_type(data, antennae[b]) then
                make_antinodes(antennae[a], antennae[b], antinodes)
            end
        end
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
