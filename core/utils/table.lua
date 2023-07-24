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

-- Checks if a table contains a value
--
-- @param table <table> to check
-- @param value <any> to check for
-- @return <boolean> true if the table contains the value, false otherwise
--
function table.contains(table, value)
    for _, v in ipairs(table) do
        if v == value then
            return true
        end
    end
    return false
end