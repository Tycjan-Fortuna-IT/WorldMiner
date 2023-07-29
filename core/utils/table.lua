--- Creates a fisher-yates shuffle of a sequential number-indexed table
-- because this uses math.random, it cannot be used outside of events if no rng is supplied
-- from: http://www.sdknews.com/cross-platform/corona/tutorial-how-to-shuffle-table-items
-- @param t <table> to shuffle
function table.shuffle_table(t, rng)
    local rand = rng or math.random
    local iterations = #t

    if iterations == 0 then
        error('Not a sequential table')
        return
    end

    local j

    for i = iterations, 2, -1 do
        j = rand(i)
        t[i], t[j] = t[j], t[i]
    end
end

--- Check if a table contains a value
--- @param tbl table
--- @param value any
--- @return boolean
function table.contains(tbl, value)
    for _, v in ipairs(tbl) do
        if v == value then
            return true
        end
    end

    return false
end

--- Sorts a table by the given key in ascending order
--- @param tbl table
--- @param key string
--- @return table
function table.sort_by_asc(tbl, key)
    table.sort(tbl, function(a, b)
        return a[key] < b[key]
    end)

    return tbl
end

--- Sorts a table by the given key in descending order
--- @param tbl table
--- @param key string
--- @return table
function table.sort_by_desc(tbl, key)
    table.sort(tbl, function(a, b)
        return a[key] > b[key]
    end)

    return tbl
end

--- Returns a random element from a table
--- @param tbl table
--- @return any
function table.random(tbl)
    return tbl[math.random(#tbl)]
end

--- Returns first element of a table
--- @param tbl table
--- @return any
function table.first(tbl)
    return tbl[1]
end

--- Returns last element of a table
--- @param tbl table
--- @return any
function table.last(tbl)
    return tbl[#tbl]
end

--- Returns a random key from a table
--- @param tbl table
--- @return any
function table.random_key(tbl)
    local keys = {}

    for k, _ in pairs(tbl) do
        keys[#keys + 1] = k
    end

    return keys[math.random(#keys)]
end