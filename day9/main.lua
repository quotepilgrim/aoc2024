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
    for i = 1, #line do
        table.insert(data, line:sub(i, i))
    end

    file:close()
    return data
end

local function part_one()
    local data = get_data(filename)
    if data == nil then
        return
    end
    local disk = {}
    local id = 0
    for i = 1, #data do
        local mod = math.fmod(i, 2)
        for _ = 1, data[i] do
            if mod == 1 then
                table.insert(disk, id)
            else
                table.insert(disk, ".")
            end
        end
        if mod == 1 then
            id = id + 1
        end
    end
    local l = 1
    local r = #disk
    local changed = true
    while l < r and changed do
        changed = false
        if disk[r] ~= "." then
            for i = l, r do
                if disk[i] == "." then
                    changed = true
                    disk[i] = disk[r]
                    disk[r] = "."
                    l = i + 1
                    break
                end
            end
        else
            changed = true
            r = r - 1
        end
    end
    for i, v in ipairs(disk) do
        if v ~= "." then
            answer = answer + (i - 1) * v
        else
            break
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
