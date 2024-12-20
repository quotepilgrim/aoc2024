local filename = ""
local results = {}
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
        local changes = {}
        for i = 1, #t - 1, 1 do
            table.insert(changes, t[i] - t[i + 1])
        end

        local result = "safe"
        for i = 1, #changes, 1 do
            if math.abs(changes[i]) > 3 then
                result = "unsafe"
            end
            if changes[i] == 0 then
                result = "unsafe"
            end
            if i == #changes then
                break
            end
            if changes[i] * changes[i + 1] < 0 then
                result = "unsafe"
            end
        end

        table.insert(results, result)
    end

    for _, v in ipairs(results) do
        if v == "safe" then
            answer = answer + 1
        end
    end
end

local function is_safe(t, skip)
    local pup, up
    local change = 0
    local result = true
    local newt = {}

    for i, v in ipairs(t) do
        newt[i] = v
    end
    
    table.remove(newt, skip)

    for i = 1, #newt - 1, 1 do
        change = newt[i] - newt[i + 1]

        if change == 0 or math.abs(change) > 3 then
            result = false
        end

        up = change < 0

        if pup ~= nil and pup ~= up then
            result = false
        end

        pup = up
    end
    return result
end

local function part_two()
    local data = get_data(filename)
    if data == nil then
        return
    end

    for _, t in ipairs(data) do
        local safe = false
        for i = 1, #t, 1 do
            safe = is_safe(t, i)
            if safe then
                break
            end
        end
        table.insert(results, safe)
    end

    for _, v in ipairs(results) do
        if v then
            answer = answer + 1
        end
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
