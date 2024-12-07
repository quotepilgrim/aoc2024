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
        local result, equation = line:match("(.-):(.*)")
        local split = {}
        local tokens = equation:gmatch("[^%s]+")
        for token in tokens do
            table.insert(split, tonumber(token))
        end
        table.insert(data, { result, split })
        line = file:read()
    end

    file:close()
    return data
end

local function calculate(eq, ops)
    local result = eq[1]
    for i = 1, #eq - 1 do
        if ops[i] == "+" then
            result = result + eq[i + 1]
        elseif ops[i] == "*" then
            result = result * eq[i + 1]
        end
    end
    return result
end

local function part_one()
    local data = get_data(filename)
    if data == nil then
        return
    end
    local expected
    local equation = {}
    for _, line in ipairs(data) do
        local ops = {}
        expected = tonumber(line[1])
        equation = line[2]
        for _ = 1, #equation - 1 do
            table.insert(ops, "+")
        end
        local done = false
        local result = 0
        while not done do
            result = calculate(equation, ops)
            if result == expected then
                answer = answer + expected
                break
            end
            for i = #ops, 1, -1 do
                if ops[i] == "+" then
                    ops[i] = "*"
                    break
                elseif ops[i] == "*" then
                    ops[i] = "+"
                end
                if i == 1 then
                    done = true
                end
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
