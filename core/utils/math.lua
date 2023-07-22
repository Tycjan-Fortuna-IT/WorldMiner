local map_config = require("core.config.config")

---
-- Shuffles the elements of a given table randomly.
--
-- This function modifies the original table in place and does not create a new one.
--
-- @param tbl The input table to be shuffled. It should be a sequence (array-like) table with integer keys starting from 1.
-- @return The shuffled table with its elements randomly rearranged.
-- 
local function shuffle(table)
    local size = #table

    for i = size, 1, -1 do
        local rand = math.random(size)
        table[i], table[rand] = table[rand], table[i]
    end

    return table
end

-- Converts a coordinate pair to a string.
--
-- @param pos The coordinate pair to be converted to a string.
-- @return The string representation of the given coordinate pair.
--
local function coord_to_string(pos)
    local x = pos[1]
    local y = pos[2]
    if pos.x then
        x = pos.x
    end
    if pos.y then
        y = pos.y
    end
    return tostring(x .. '_' .. y)
end

-- Returns the cell coordinates of a given position.
--
-- @param pos The position to be converted to cell coordinates.
-- @return The cell coordinates of the given position.
--
local function get_cell_by_position(pos)
    local x = math.floor(pos.x / map_config.grid_size)
    local y = math.floor(pos.y / map_config.grid_size)

    return {x = x, y = y}
end

-- Selects a random function from an array of functions based on their weights.
--
-- @param array The array of functions to select from.
-- @return The selected function.
--
local function select_random_function_by_weight(array)
    local total_weight = 0
    for _, data in ipairs(array) do
        total_weight = total_weight + data.weight
    end

    local random_number = math.random(0, total_weight)

    for _, data in ipairs(array) do
        random_number = random_number - data.weight
        if random_number <= 0 then
            return data.func
        end
    end
end


local math = {
    shuffle = shuffle;
    coord_to_string = coord_to_string;
    get_cell_by_position = get_cell_by_position;
    select_random_by_weight = select_random_function_by_weight;
}

return math;