local config = require('core.config.config')
local map_functions = require('core.utils.map_functions')
local filler_helper = require('core.helpers.filler_helper')
local utils = require('core.utils.utils')
local lua = require('core.utils.lua')
local functions = require('core.utils.functions')


---@class Variant1x2
---@field rooms Room[] Table of rooms.
local variant1x2 = {}

--- Initialize the variant dispatcher, initialaze all rooms
--- @return nil
variant1x2.init = function()
    -- TODO make it more random i guess (guaranteed_at is a bit weird)
    variant1x2.rooms = {
        { func = variant1x2.tons_of_rocks, weight = 100, min_discovered_rooms = 0,  max_discovered_rooms = 0, guaranteed_at = { 1 } },
        { func = variant1x2.tons_of_trees, weight = 37, min_discovered_rooms = 0,  max_discovered_rooms = 0, guaranteed_at = { 2 } },
        { func = variant1x2.pond, weight = 9, min_discovered_rooms = 0,  max_discovered_rooms = 0, guaranteed_at = { 3 } },
        { func = variant1x2.ore_deposit, weight = 6, min_discovered_rooms = 0,  max_discovered_rooms = 0, guaranteed_at = { 5 } },
        { func = variant1x2.nests, weight = 4, min_discovered_rooms = 0,  max_discovered_rooms = 0, guaranteed_at = { 7 } }
    }
end

--- Initialize the cells of the room
--- @param positions table - Table of positions as a coords of left top corner of the chunk (room)
--- @return nil
variant1x2.init_cell = function(positions)
    for _, position in pairs(positions) do
        local key = utils.coord_to_string({ position.x, position.y })

        global.map_cells[key] = global.map_cells[key] or {}
        global.map_cells[key].visited = true
    end
end

--- Create a room with tons of rocks
--- @param surface LuaSurface - Surface on which the room will be placed
--- @param positions table - Table of positions as a coords of left top corner of the chunk (room)
--- @return nil
variant1x2.tons_of_rocks = function(surface, positions)
    for _, position in pairs(positions) do
        local left_top = { x = position.x * config.grid_size, y = position.y * config.grid_size }

        filler_helper.fill_with_base_tile(surface, left_top)

        map_functions.draw_spreaded_rocks_around(left_top, surface, true)
    end
end

--- Create a room with tons of trees
--- @param surface LuaSurface - Surface on which the room will be placed
--- @param positions table - Table of positions as a coords of left top corner of the chunk (room)
--- @return nil
variant1x2.tons_of_trees = function(surface, positions)
    for _, position in pairs(positions) do
        map_functions.draw_spreaded_trees_around(position, surface, true)
    end
end

--- Create a room with an ore deposit
--- @param surface LuaSurface - Surface on which the room will be placed
--- @param positions table - Table of positions as a coords of left top corner of the chunk (room)
--- @return nil
variant1x2.ore_deposit = function(surface, positions)
    local ore_name = utils.select_random_first_element_from_tuple_by_weight(config.ore_raffle)
    local center = { x = 0, y = 0 }

    for _, position in pairs(positions) do
        center.x = center.x + position.x * config.grid_size + config.grid_size * 0.5
        center.y = center.y + position.y * config.grid_size + config.grid_size * 0.5
    end

    center.x = center.x / #positions
    center.y = center.y / #positions

    local radius = math.min(center.x - positions[1].x * config.grid_size, (config.grid_size * #positions) - center.x + positions[1].x * config.grid_size, center.y - positions[1].y * config.grid_size, (config.grid_size * #positions) - center.y + positions[1].y * config.grid_size) * 0.5

    for _, position in pairs(positions) do
        local left_top = { x = position.x * config.grid_size, y = position.y * config.grid_size }

        filler_helper.fill_with_base_tile(surface, left_top)

        map_functions.draw_spreaded_rocks_around(left_top, surface, false)
        map_functions.draw_spreaded_trees_around(position, surface, false)
    end

    local distance_to_center = math.sqrt(center.x ^ 2 + center.y ^ 2)
    local max_distance = math.sqrt((config.grid_size * 0.5) ^ 2 + (config.grid_size * 0.5) ^ 2)
    local scaling_factor = math.exp(distance_to_center / (max_distance * 30)) * 3

    map_functions.draw_irregular_noise_ore_deposit(center, ore_name, surface, radius * 2, 1968 * scaling_factor, 0.2, 0.1)
end

--- Create a room with a pond
--- @param surface LuaSurface - Surface on which the room will be placed
--- @param positions table - Table of positions as a coords of left top corner of the chunk (room)
--- @return nil
variant1x2.pond = function(surface, positions)
    local center = { x = 0, y = 0 }
    for _, position in pairs(positions) do
        center.x = center.x + position.x * config.grid_size + config.grid_size * 0.5
        center.y = center.y + position.y * config.grid_size + config.grid_size * 0.5
    end
    center.x = center.x / #positions
    center.y = center.y / #positions

    local radius = math.min(center.x - positions[1].x * config.grid_size, (config.grid_size * #positions) - center.x + positions[1].x * config.grid_size, center.y - positions[1].y * config.grid_size, (config.grid_size * #positions) - center.y + positions[1].y * config.grid_size) * 0.5

    for _, position in pairs(positions) do
        local left_top = { x = position.x * config.grid_size, y = position.y * config.grid_size }

        filler_helper.fill_with_base_tile(surface, left_top)

        map_functions.draw_spreaded_rocks_around(left_top, surface, false)
        map_functions.draw_spreaded_trees_around(position, surface, false)
    end

    map_functions.draw_noise_tile_circle(center, 'water', surface, radius)

    local fish_count = math.floor(radius * 2)
    for i = 1, fish_count do
        local angle = math.random() * 2 * math.pi
        local distance = math.random() * radius
        local x = center.x + distance * math.cos(angle)
        local y = center.y + distance * math.sin(angle)
        surface.create_entity({ name = 'fish', position = { x, y } })
    end
end

--- Create a room with nests
--- @param surface LuaSurface - Surface on which the room will be placed
--- @param positions table - Table of positions as a coords of left top corner of the chunk (room)
--- @return nil
variant1x2.nests = function(surface, positions)
    local amount = math.ceil(functions.get_biter_amount() * 0.4)
    local tile_positions = {}

    for _, position in pairs(positions) do
        for x = 0.5, config.grid_size - 0.5, 1 do
            for y = 0.5, config.grid_size - 0.5, 1 do
                local pos = { position.x * config.grid_size + x, position.y * config.grid_size + y }
                tile_positions[#tile_positions + 1] = pos
            end
        end
    end

    for _, position in pairs(positions) do
        local left_top = { x = position.x * config.grid_size, y = position.y * config.grid_size }
        filler_helper.fill_with_base_tile(surface, left_top)
    end

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

    for _, position in pairs(positions) do
        local left_top = { x = position.x * config.grid_size, y = position.y * config.grid_size }
        map_functions.draw_spreaded_rocks_around(left_top, surface, false)
        map_functions.draw_spreaded_trees_around(left_top, surface, false)
    end
end

--- Check if available room can be placed at a given direction.
--- @param position table - Left top corner of the first cell for the new room
--- @param direction defines.direction - Direction in which the room will be placed
--- @return boolean
variant1x2.can_expand = function (position, direction)
    for _, offset in pairs(variant1x2.get_offsets(position, direction, true)) do
        if variant1x2.can_expand_offset(offset) then
            return true
        end
    end

    return false
end

--- Check if there is room at given offset that is position of one of the cells of the room.
--- @param offset table - Offset from the left top corner
--- @return boolean
variant1x2.can_expand_offset = function (offset)
    if not global.map_cells[utils.coord_to_string({ offset.x, offset.y })] then
        return true
    end

    if not global.map_cells[utils.coord_to_string({ offset.x, offset.y })].visited then
        return true
    end

    return false
end

--- Get a list of positions where the room can be expanded. If multiple positions are available, set will be chosen randomly.
--- @param position table - Left top corner of the first cell for the new room
--- @param direction defines.direction - Direction in which the room will be placed
--- @return table
variant1x2.get_random_expandable_positions = function (position, direction)
    local available_positions = {}
    
    for _, offset in pairs(variant1x2.get_offsets(position, direction, false)) do
        if variant1x2.can_expand(offset, direction) then
            table.insert(available_positions, offset)
        end
    end

    return available_positions
end

--- Get a list of offsets where the room can be expanded.
--- @param position table - Left top corner of the first cell for the new room
--- @param direction defines.direction - Direction in which the room will be placed
--- @param without_base_offset boolean? - Do include the base offset in the list
--- @return table
variant1x2.get_offsets = function (position, direction, without_base_offset)
    local offsets = lua.ternary(without_base_offset, {}, { { x = position.x, y = position.y } })

    if direction == defines.direction.north then
        table.insert(offsets, { x = position.x, y = position.y - 1 })
    elseif direction == defines.direction.south then
        table.insert(offsets, { x = position.x, y = position.y + 1 })
    elseif direction == defines.direction.east then
        table.insert(offsets, { x = position.x + 1, y = position.y })
    elseif direction == defines.direction.west then
        table.insert(offsets, { x = position.x - 1, y = position.y })
    else
        error('E0001 - Invalid direction: ' .. direction)
    end

    return offsets
end

return variant1x2