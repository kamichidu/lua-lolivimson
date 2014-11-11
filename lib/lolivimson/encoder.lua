local encoder= {}

function encoder.encode(data)
    local fname= 'encode_' .. type(data)

    return encoder[fname](data)
end

function encoder.encode_table(data)
    if encoder._is_list(data) then
        local s= ''
        s= s .. '['
        for _, element in ipairs(data) do
            s= s .. encoder.encode(element)
            s= s .. ','
        end
        s= s .. ']'
        return s
    else
        local s= ''
        s= s .. '{'
        for key, value in pairs(data) do
            s= s .. encoder.encode_string(key)
            s= s .. ':'
            s= s .. encoder.encode(value)
            s= s .. ','
        end
        s= s .. '}'
        return s
    end
end

function encoder.encode_number(data)
    return string.format('%.9f', data)
end

function encoder.encode_nil(data)
    return '0'
end

function encoder.encode_boolean(data)
    if data then
        return '1'
    else
        return '0'
    end
end

function encoder.encode_string(data)
    return "'" .. data:gsub("'", "''") .. "'"
end

function encoder.encode_function(data)
    error("Can't handle function value.")
end

function encoder.encode_userdata(data)
    error("Can't handle userdata value.")
end

function encoder.encode_thread(data)
    error("Can't handle thread value.")
end

function encoder._is_list(tbl)
    local a= 0
    for _, _ in pairs(tbl) do
        a= a + 1
    end

    local b= 0
    for _, _ in ipairs(tbl) do
        b= b + 1
    end

    return a == b
end

return encoder
