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
        local split = {}
        for i = 1, line:len() do
            table.insert(split, line:sub(i, i))
        end
        table.insert(data, split)
        line = file:read()
    end

    file:close()
    return data
end

local function print_data(data)
    for i = 1, #data do
        for j = 1, #data[1] do
            io.write(data[i][j])
        end
        io.write("\n")
    end
end

local function part_one()
    local data = get_data(filename)
    if data == nil then
        return
    end
    local exited = false
    while not exited do
        for i = 1, #data do
            for j = 1, #data[1] do
                if data[i][j] == "^" then
                    if i == 1 then
                        data[i][j] = "x"
                        exited = true
                    elseif data[i - 1][j] == "#" then
                        data[i][j] = ">"
                    else
                        data[i][j] = "x"
                        data[i - 1][j] = "^"
                    end
                end
                if data[i][j] == ">" then
                    if j == #data[1] then
                        data[i][j] = "x"
                        exited = true
                    elseif data[i][j + 1] == "#" then
                        data[i][j] = "v"
                    else
                        data[i][j] = "x"
                        data[i][j + 1] = ">"
                    end
                end
                if data[i][j] == "v" then
                    if i == #data then
                        data[i][j] = "x"
                        exited = true
                    elseif data[i + 1][j] == "#" then
                        data[i][j] = "<"
                    else
                        data[i][j] = "x"
                        data[i + 1][j] = "v"
                    end
                end
                if data[i][j] == "<" then
                    if j == 1 then
                        data[i][j] = "x"
                        exited = true
                    elseif data[i][j - 1] == "#" then
                        data[i][j] = "^"
                    else
                        data[i][j] = "x"
                        data[i][j - 1] = "<"
                    end
                end
            end
        end
    end
    for _, t in ipairs(data) do
        for _, v in ipairs(t) do
            if v == "x" then
                answer = answer + 1
            end
        end
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
