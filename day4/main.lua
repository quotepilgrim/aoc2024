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
        local chars = {}
        for i = 1, #line do
            table.insert(chars, line:sub(i, i))
        end
        table.insert(data, chars)
        line = file:read()
    end

    file:close()
    return data
end

local function get_horizontal(t, i, j)
    local word = ""
    for x = 0, 3 do
        local char = t[i][j + x]
        if char ~= nil then
            word = word .. char
        end
    end
    return word
end

local function get_vertical(t, i, j)
    local word = ""
    for x = 0, 3 do
        if t[i + x] == nil then
            break
        end
        local char = t[i + x][j]
        word = word .. char
    end
    return word
end

local function get_diagonal(t, i, j, backwards)
    local word = ""
    local char
    backwards = backwards or false
    for x = 0, 3 do
        if t[i + x] == nil then
            break
        end
        if backwards then
            char = t[i + x][j - x]
        else
            char = t[i + x][j + x]
        end
        if char ~= nil then
            word = word .. char
        end
    end
    return word
end

local function get_xword(t, i, j)
    if i + 2 > #t or j + 2 > #t[1] then
        return ""
    end
    return t[i][j] .. t[i][j + 2] .. t[i + 1][j + 1] .. t[i + 2][j] .. t[i + 2][j + 2]
end

local function part_one()
    local data = get_data(filename)
    if data == nil then
        return
    end
    for i = 1, #data do
        for j = 1, #data[1] do
            local horz_word = get_horizontal(data, i, j)
            local vert_word = get_vertical(data, i, j)
            local diag_word = get_diagonal(data, i, j)
            local anti_word = get_diagonal(data, i, j, true)
            if horz_word == "XMAS" or horz_word == "SAMX" then
                answer = answer + 1
            end
            if vert_word == "XMAS" or vert_word == "SAMX" then
                answer = answer + 1
            end
            if diag_word == "XMAS" or diag_word == "SAMX" then
                answer = answer + 1
            end
            if anti_word == "XMAS" or anti_word == "SAMX" then
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
    for i = 1, #data do
        for j = 1, #data[1] do
            local word = get_xword(data, i, j)
            if word == "MMASS" or word == "MSAMS" or word == "SMASM" or word == "SSAMM" then
                answer = answer + 1
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
