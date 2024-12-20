local filename = ""
local answer = 0

local function get_data(input)
    local data = {}
    local file = io.open(input, "r")

    if file == nil then
        love.event.quit()
        return
    end

    data = file:read("*all")

    file:close()
    return data
end

local function part_one()
    local data = get_data(filename)
    if data == nil then
        return
    end
    for a, b in data:gmatch("mul%((%d%d?%d?),(%d%d?%d?)%)") do
        answer = answer + a * b
    end
end

local function part_two()
    local data = get_data(filename)
    if data == nil then
        return
    end
    local x, y
    local mul_enabled = true
    for a in data:gmatch("d?o?[mn]?[u'd][lto]%(.-%)") do
        if a:sub(-4) == "do()" then
            mul_enabled = true
        elseif a:sub(-7) == "don't()" then
            mul_enabled = false
        elseif mul_enabled and a:sub(1, 4) == "mul(" then
            x, y = a:match("mul%((%d%d?%d?),(%d%d?%d?)%)")
            if x ~= nil and y ~= nil then
                answer = answer + x * y
            end
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
