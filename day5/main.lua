local filename = ""
local answer = 0

local function get_data(input)
    local rules = {}
    local updates = {}

    local file = io.open(input, "r")
    if file == nil then
        love.event.quit()
        return
    end

    local line = file:read()
    while line ~= "" do
        table.insert(rules, line)
        line = file:read()
    end

    while line ~= nil do
        table.insert(updates, line)
        line = file:read()
    end

    file:close()
    return rules, updates
end

local function part_one()
    local rules, updates = get_data(filename)
    if rules == nil or updates == nil then
        return
    end
    print(table.concat(rules, "\n"))
    io.write("---")
    print(table.concat(updates, "\n"))
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
