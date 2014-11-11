local decoder= {}

function decoder.decode(text)
    local chars= {}
    for c in text:gsub('\r?\n%s*\\', ''):gmatch('.') do
        table.insert(chars, c)
    end

    local value= decoder.parse(chars, 1)
    return value
end

function decoder.parse(chars, p)
    local p= decoder.ignore(chars, p)

    if chars[p] == '"' or chars[p] == "'" then
        return decoder.parse_string(chars, p)
    elseif chars[p] == '[' then
        return decoder.parse_list(chars, p)
    elseif chars[p] == '{' then
        return decoder.parse_dictionary(chars, p)
    else
        return decoder.parse_number(chars, p)
    end
end

function decoder.parse_number(chars, p)
    local p= decoder.ignore(chars, p)
    local n= 0

    while chars[p]:find('^%d') do
        p= p + 1
    end

    return n, p
end

function decoder.parse_string(chars, p)
    local p= decoder.ignore(chars, p)
    local s= ''

    if chars[p] == '"' then
        p= p + 1
        while true do
            if chars[p] == '\\' then
                p= p + 1
                if chars[p] == '"' then
                    s= s .. '"'
                end
            elseif chars[p] == '"' then
                p= p + 1
                break
            else
                s= s .. chars[p]
                p= p + 1
            end
        end
    elseif chars[p] == "'" then
        p= p + 1
        while true do
            if chars[p] == "'" and chars[p + 1] == "'" then
                s= s .. "'"
                p= p + 2
            elseif chars[p] == "'" then
                p= p + 1
                break
            else
                s= s .. chars[p]
                p= p + 1
            end
        end
    else
        error('Malformed')
    end

    return s, p
end

function decoder.parse_list(chars, p)
    local p= decoder.ignore(chars, p)
    local list= {}

    assert(chars[p] == '[')
    p= p + 1

    p= decoder.ignore(chars, p)
    while chars[p] ~= ']' do
        local element, p= decoder.parse(chars, p)
        table.insert(list, element)

        p= decoder.ignore(chars, p)
        if chars[p] == ',' then
            p= p + 1
        end

        p= decoder.ignore(chars, p)
    end

    assert(chars[p] == ']')
    p= p + 1

    return list, p
end

function decoder.parse_dictionary(chars, p)
    local p= decoder.ignore(chars, p)
    local dict= {}

    assert(chars[p] == '{')
    p= p + 1

    p= decoder.ignore(chars, p)
    while chars[p] ~= '}' do
        local key, p= decoder.parse(chars, p)

        p= decoder.ignore(chars, p)
        assert(chars[p] == ':')
        p= p + 1

        local value, p= decoder.parse(chars, p)

        dict[key]= value

        p= decoder.ignore(chars, p)
        if chars[p] == ',' then
            p= p + 1
        end

        p= decoder.ignore(chars, p)
    end

    assert(chars[p] == '}')
    p= p + 1

    return dict, p
end

function decoder.ignore(chars, p)
    for i= p, #chars do
        if not (chars[i] == ' ' or chars[i] == '\t') then
            return i
        end
    end
    return #chars + 1
end

return decoder
