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

local function is_greater(a, b, rules)
    local a_pos, b_pos
    for _, rule in ipairs(rules) do
        a_pos = rule:find(a)
        b_pos = rule:find(b)
        if a_pos and b_pos then
            return a_pos > b_pos
        end
    end
    return nil
end

local function is_valid(s, rules)
    local valid = true
    for _, r in ipairs(rules) do
        local a, b = r:match("(.+)|(.+)")
        local a_pos = s:find(a)
        local b_pos = s:find(b)
        if a_pos and b_pos and a_pos > b_pos then
            valid = false
            break
        end
    end
    return valid
end

local function bubblesort(t, rules)
    local swapped
    repeat
        swapped = false
        for i = 2, #t do
            if is_greater(t[i - 1], t[i], rules) then
                t[i - 1], t[i] = t[i], t[i - 1]
                swapped = true
            end
        end
    until not swapped
end

local function part_one()
    local rules, updates = get_data(filename)
    if rules == nil or updates == nil then
        return
    end
    for _, u in ipairs(updates) do
        if is_valid(u, rules) then
            local t = {}
            for i in u:gmatch("([^,]+)") do
                table.insert(t, i)
            end
            local middle = t[math.ceil(#t / 2)] or 0
            answer = answer + middle
        end
    end
end

local function part_two()
    local rules, updates = get_data(filename)
    if rules == nil or updates == nil then
        return
    end
    for _, u in ipairs(updates) do
        if not is_valid(u, rules) then
            local t = {}
            for i in u:gmatch("[^,]+") do
                table.insert(t, i)
            end
            bubblesort(t, rules)
            local middle = t[math.ceil(#t / 2)] or 0
            answer = answer + middle
        end
    end
    is_greater(1, 2, rules)
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
