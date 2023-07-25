local map_config = require("core.config.config")

local utils = {}

---
-- Shuffles the elements of a given table randomly.
--
-- This function modifies the original table in place and does not create a new one.
--
-- @param tbl The input table to be shuffled. It should be a sequence (array-like) table with integer keys starting from 1.
-- @return The shuffled table with its elements randomly rearranged.
--
utils.shuffle = function (table)
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
utils.coord_to_string = function (pos)
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
utils.get_cell_by_position = function (pos)
    local x = math.floor(pos.x / map_config.grid_size)
    local y = math.floor(pos.y / map_config.grid_size)

    return { x = x, y = y }
end

-- Selects a random function from an array of functions based on their weights.
--
-- @param array The array of functions to select from.
-- @return The selected function.
--
utils.select_random_function_by_weight = function(array)
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

-- Selects a random element from a table of elements based on their weights.
--
-- @param array The array of elements to select from.
-- @return The selected element.
--
utils.select_random_first_element_from_tuple_by_weight = function (table)
    local total_weight = 0
    for _, data in ipairs(table) do
        total_weight = total_weight + data[2]
    end

    local random_number = math.random(0, total_weight)

    for _, data in ipairs(table) do
        random_number = random_number - data[2]
        if random_number <= 0 then
            return data[1]
        end
    end
end

-- Selects a random element from a table of elements based on their weights.
--
-- @param array The array of elements to select from.
-- @return The selected element.
--
utils.select_random_element_from_table_by_weight = function(table)
    local total_weight = 0
    for _, data in ipairs(table) do
        total_weight = total_weight + data.weight
    end

    local random_number = math.random(0, total_weight)

    for _, data in ipairs(table) do
        random_number = random_number - data.weight
        if random_number <= 0 then
            return data
        end
    end
end

-- Generates the price of a pickaxe tier based on its index.
--
-- @param tier_index The index of the pickaxe tier.
-- @return The price of the pickaxe tier.
--
utils.generate_pickaxe_tier_price = function(tier_index)
    local base_price = 100
    local base_multiplier = 1.1
    local growth_multiplier = 1.015

    local price = math.floor(base_price * math.pow(base_multiplier, tier_index) + tier_index ^ 2 * growth_multiplier)

    return price
end

-- Generates the price of a backpack tier based on its index.
--
-- @param tier_index The index of the backpack tier.
-- @return The price of the backpack tier.
--
utils.generate_backpack_tier_price = function(tier_index)
    local base_price = 140
    local base_multiplier = 1.08
    local growth_multiplier = 1.215

    local price = math.floor(base_price * math.pow(base_multiplier, tier_index) + tier_index ^ 2 * growth_multiplier)

    return price
end

-- Adjusts the weight of a room based on the number of discovered rooms.
--
-- @param weight The base weight of the room.
-- @param min_discovered_rooms The minimum number of rooms that must be discovered before this room can appear.
-- @return The adjusted weight of the room.
--
utils.adjust_weight_based_on_discovered_rooms = function(weight, min_discovered_rooms)
    if global.discovered_cells < min_discovered_rooms then
        return 0  -- Set weight to 0 for rooms that should not appear until a certain number of rooms are discovered
    else
        local base_weight = weight * 10  -- Adjust the multiplier value as needed
        local weight_adjustment = 1 + ((global.discovered_cells - min_discovered_rooms) / 100)
        return base_weight * weight_adjustment
    end
end

-- Selects a random room from a table of rooms based on their weights.
--
-- @param rooms The table of rooms to select from.
-- @return The selected room.
--
utils.select_random_room = function (room_weights)
    local total_weight = 0
    local discovered_rooms = global.discovered_cells or 0
    local valid_rooms = {}

    for _, room_info in pairs(room_weights) do
        if discovered_rooms >= room_info.min_discovered_rooms then
            for i = 1, room_info.weight do
                total_weight = total_weight + 1
                valid_rooms[total_weight] = room_info.func
            end
        end
    end

    -- Check if any rooms are guaranteed to spawn at certain points
    for _, room_info in pairs(room_weights) do
        if #room_info.guaranteed_at > 0 then
            for _, guaranteed_point in ipairs(room_info.guaranteed_at) do
                if discovered_rooms == guaranteed_point then
                    return room_info.func
                end
            end
        end
    end

    -- Randomly choose a valid room
    local random_value = math.random(1, total_weight)

    return valid_rooms[random_value]
end


-- Selects a random fluid from a table of fluids that have not yet been placed.
--
-- @param tbl The table of fluids to select from.
-- @return The selected fluid.
--
utils.select_fluids_not_yet_placed = function (tbl)
    local fluids_not_yet_placed = {}

    for _, fluid in ipairs(tbl) do
        if not global.fluids_placed[fluid.name] then
            table.insert(fluids_not_yet_placed, fluid)
        end
    end

    return fluids_not_yet_placed
end

return utils;
