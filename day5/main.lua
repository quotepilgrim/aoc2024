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
    for _, u in ipairs(updates) do
        local valid = true
        for _, r in ipairs(rules) do
            local a, b = r:match("(.+)|(.+)")
            local a_pos = u:find(a)
            local b_pos = u:find(b)
            if a_pos ~= nil and b_pos ~= nil and a_pos > b_pos then
                valid = false
                break
            end
        end
        if valid then
            local t ={}
            for i in u:gmatch("([^,]+)") do
                table.insert(t, i)
            end
            local middle = t[math.ceil(#t/2)] or 0
            answer = answer + middle
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
