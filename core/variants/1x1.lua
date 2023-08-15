local map_functions = require('core.utils.map_functions')
local filler_helper = require('core.helpers.filler_helper')
local utils = require('core.utils.utils')
local functions = require('core.utils.functions')
require('core.utils.table')


---@class Room
---@field func function Function responsible for creating given room.
---@field weight number Weight of the variant. Increasing the weight will increase the chance of the variant being used.
---@field min_discovered_rooms number Minimum number of discovered rooms required for the room to be available.
---@field max_discovered_rooms number Maximum number of discovered rooms allowed for the room to be available.
---@field guaranteed_at table Levels at which the room is guaranteed to be used.

---@class Variant1x1
---@field rooms Room[] Table of rooms.
local variant1x1 = {}


--- Initialize the variant dispatcher, initialaze all rooms
--- @return nil
variant1x1.init = function()
    -- TODO make it more random i guess (guaranteed_at and dungeon_at is a bit weird)
    -- func - callback function responsible for creating given room
    -- Weight - increasing the weight will increase the chance of the variant being used
    -- Min discovered rooms - minimum number of TOTAL discovered rooms OF GIVEN VARIANT(not total of all variants) required for the variant to be available
    -- Max discovered rooms - maximum number of TOTAL discovered rooms OF GIVEN VARIANT(not total of all variants) allowed for the variant to be available or 0 for unlimited
    -- Guaranteed at - levels at which the variant is guaranteed to be used
    variant1x1.rooms = {
        { func = variant1x1.tons_of_rocks, weight = 50, min_discovered_rooms = 0,  max_discovered_rooms = 0, guaranteed_at = { 1 } },
        { func = variant1x1.tons_of_trees, weight = 14,  min_discovered_rooms = 0,  max_discovered_rooms = 0, guaranteed_at = { 2 } },
        { func = variant1x1.pond,          weight = 9,   min_discovered_rooms = 0,  max_discovered_rooms = 0, guaranteed_at = { 3 } },
        { func = variant1x1.ore_deposit,   weight = 6,   min_discovered_rooms = 10, max_discovered_rooms = 0, guaranteed_at = { 11 } },
        { func = variant1x1.nests,         weight = 4,   min_discovered_rooms = 10, max_discovered_rooms = 0, guaranteed_at = { 12 } },
        { func = variant1x1.oil,           weight = 4,   min_discovered_rooms = 15, max_discovered_rooms = 0, guaranteed_at = { 16, 25, 37, 50 } },
    }
end

--- Initialize the cells of the room
--- @param positions table - Table of positions as a coords of left top corner of the chunk (room)
--- @return nil
variant1x1.init_cell = function(positions)
    for _, position in pairs(positions) do
        local key = utils.coord_to_string({ position.x, position.y })
        global.map_cells[key] = global.map_cells[key] or {}
        global.map_cells[key].visited = true
    end

    global.discovered_cells = global.discovered_cells + 1
end

--- Create a room with tons of rocks
--- @param surface LuaSurface - Surface on which the room will be placed
--- @param positions table - Table of positions as a coords of left top corner of the chunk (room)
--- @return nil
variant1x1.tons_of_rocks = function(surface, positions)
    local left_top = { x = positions[1].x * global.config.grid_size, y = positions[1].y * global.config.grid_size }

    filler_helper.fill_with_base_tile(surface, left_top)

    map_functions.draw_spreaded_rocks_around(left_top, surface, true)
end

--- Create a room with tons of trees
--- @param surface LuaSurface - Surface on which the room will be placed
--- @param positions table - Table of positions as a coords of left top corner of the chunk (room)
--- @return nil
variant1x1.tons_of_trees = function(surface, positions)
    local left_top = { x = positions[1].x * global.config.grid_size, y = positions[1].y * global.config.grid_size }

    filler_helper.fill_with_base_tile(surface, left_top)

    map_functions.draw_spreaded_trees_around(positions[1], surface, true)
end

--- Create a room with some oil deposits
--- @param surface LuaSurface - Surface on which the room will be placed
--- @param positions table - Table of positions as a coords of left top corner of the chunk (room)
--- @return nil
variant1x1.oil = function(surface, positions)
    local num_of_oils = 3 + math.floor(global.discovered_cells / 100)
    local left_top = { x = positions[1].x * global.config.grid_size, y = positions[1].y * global.config.grid_size }

    local fluids = utils.select_fluids_not_yet_placed(global.config.fluid_raffle)

    local fluid

    if next(fluids) ~= nil then
        fluid = utils.select_random_element_from_table_by_weight(fluids)

        global.fluids_placed[fluid.name] = true
    else
        fluid = utils.select_random_element_from_table_by_weight(global.config.fluid_raffle)
    end

    filler_helper.fill_with_base_tile(surface, left_top)

    local square_size = 9

    for i = 1, num_of_oils do
        local center_x = left_top.x + global.config.grid_size * 0.5
        local center_y = left_top.y + global.config.grid_size * 0.5

        local corner_positions = {
            { x = center_x - square_size / 2, y = center_y - square_size / 2 },
            { x = center_x + square_size / 2, y = center_y - square_size / 2 },
            { x = center_x - square_size / 2, y = center_y + square_size / 2 },
            { x = center_x + square_size / 2, y = center_y + square_size / 2 }
        }

        for _, corner_position in ipairs(corner_positions) do
            surface.create_entity({
                name = fluid and fluid.name or 'crude-oil',
                position = corner_position,
                amount = 10000 + global.discovered_cells * 400 * (fluid and fluid.scale or 100)
            })
        end
    end

    map_functions.draw_spreaded_rocks_around(left_top, surface, false)
    map_functions.draw_spreaded_trees_around(positions[1], surface, false)
end

--- Create a room with an ore deposit
--- @param surface LuaSurface - Surface on which the room will be placed
--- @param positions table - Table of positions as a coords of left top corner of the chunk (room)
--- @return nil
variant1x1.ore_deposit = function(surface, positions)
    local ore_name = utils.select_random_first_element_from_tuple_by_weight(global.config.ore_raffle)
    local left_top = { x = positions[1].x * global.config.grid_size, y = positions[1].y * global.config.grid_size }

    filler_helper.fill_with_base_tile(surface, left_top)

    local center_x = left_top.x + global.config.grid_size * 0.5
    local center_y = left_top.y + global.config.grid_size * 0.5

    local distance_to_center = math.sqrt(center_x ^ 2 + center_y ^ 2)
    local max_distance = math.sqrt((global.config.grid_size * 0.5) ^ 2 + (global.config.grid_size * 0.5) ^ 2)
    local scaling_factor = math.exp(distance_to_center / (max_distance * 30)) * 13

    map_functions.draw_irregular_noise_ore_deposit(
        { x = left_top.x + global.config.grid_size * 0.5, y = left_top.y + global.config.grid_size * 0.5 }, ore_name, surface,
        global.config.grid_size * 0.3, 1968 * scaling_factor, 0.2, 0.1)

    map_functions.draw_spreaded_rocks_around(left_top, surface, false)
    map_functions.draw_spreaded_trees_around(positions[1], surface, false)
end

--- Create a room with a pond
--- @param surface LuaSurface - Surface on which the room will be placed
--- @param positions table - Table of positions as a coords of left top corner of the chunk (room)
--- @return nil
variant1x1.pond = function(surface, positions)
    local left_top = { x = positions[1].x * global.config.grid_size, y = positions[1].y * global.config.grid_size }

    filler_helper.fill_with_base_tile(surface, left_top)

    local center = { x = left_top.x + global.config.grid_size * 0.5, y = left_top.y + global.config.grid_size * 0.5 }
    local radius = global.config.grid_size * 0.3

    map_functions.draw_noise_tile_circle(center, 'water', surface, radius)
    map_functions.spawn_fish(center, surface, radius)
    map_functions.draw_spreaded_trees_around(positions[1], surface, false)
end

--- Create a room with nests
--- @param surface LuaSurface - Surface on which the room will be placed
--- @param positions table - Table of positions as a coords of left top corner of the chunk (room)
--- @return nil
variant1x1.nests = function(surface, positions)
    local amount = math.ceil(functions.get_biter_amount() * 0.1)
    local tile_positions = {}
    local left_top = { x = positions[1].x * global.config.grid_size, y = positions[1].y * global.config.grid_size }

    for x = 0.5, global.config.grid_size - 0.5, 1 do
        for y = 0.5, global.config.grid_size - 0.5, 1 do
            local pos = { left_top.x + x, left_top.y + y }
            tile_positions[#tile_positions + 1] = pos
        end
    end

    filler_helper.fill_with_base_tile(surface, left_top)

    table.shuffle_table(tile_positions)

    for _, pos in pairs(tile_positions) do
        if surface.can_place_entity({ name = 'spitter-spawner', position = pos }) then
            if math.random(1, 4) == 1 then
                surface.create_entity({ name = 'spitter-spawner', position = pos, force = 'enemy' })
            else
                surface.create_entity({ name = 'biter-spawner', position = pos, force = 'enemy' })
            end
            amount = amount - 1
        end
        if amount < 1 then
            break
        end
    end

    map_functions.draw_spreaded_rocks_around(left_top, surface, false)
    map_functions.draw_spreaded_trees_around(positions[1], surface, false)
end

--- Check if available room can be placed at a given position at a given direction.
--- @param position table - Left top corner of the first cell for the new room
--- @param direction defines.direction - Direction in which the room will be placed
--- @return boolean
variant1x1.can_expand = function (position, direction)
    -- 1x1 variant has no restrictions
    return true
end

--- Get a list of positions where the room can be expanded. If multiple positions are available, set will be chosen randomly.
--- @param position table - Left top corner of the first cell for the new room
--- @param direction defines.direction - Direction in which the room will be placed
--- @return table
variant1x1.get_random_expandable_positions = function (position, direction)
    -- 1x1 variant has no multiple positions
    return { position }
end

return variant1x1
