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

local math = {
    shuffle = shuffle;
    coord_to_string = coord_to_string;
    get_cell_by_position = get_cell_by_position;
}

return math;