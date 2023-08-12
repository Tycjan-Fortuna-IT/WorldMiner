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
    -- TODO make it more random i guess (guaranteed_at and dungeon_at is a bit weird)
    -- func - callback function responsible for creating given room
    -- Weight - increasing the weight will increase the chance of the variant being used
    -- Min discovered rooms - minimum number of TOTAL discovered rooms OF GIVEN VARIANT(not total of all variants) required for the variant to be available
    -- Max discovered rooms - maximum number of TOTAL discovered rooms OF GIVEN VARIANT(not total of all variants) allowed for the variant to be available or 0 for unlimited
    -- Guaranteed at - levels at which the variant is guaranteed to be used
    variant1x2.rooms = {
        { func = variant1x2.tons_of_rocks, weight = 37, min_discovered_rooms = 0,  max_discovered_rooms = 0, guaranteed_at = { 1 } },
        { func = variant1x2.ore_deposit,   weight = 27,   min_discovered_rooms = 0,  max_discovered_rooms = 0, guaranteed_at = { 5 } },
        { func = variant1x2.tons_of_trees, weight = 14,  min_discovered_rooms = 0,  max_discovered_rooms = 0, guaranteed_at = { 2 } },
        { func = variant1x2.pond,          weight = 9,   min_discovered_rooms = 0,  max_discovered_rooms = 0, guaranteed_at = { 3 } },
        { func = variant1x2.nests,         weight = 4,   min_discovered_rooms = 0,  max_discovered_rooms = 0, guaranteed_at = { 7 } }
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

    global.discovered_cells = global.discovered_cells + 2
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
        local left_top = { x = position.x * config.grid_size, y = position.y * config.grid_size }

        filler_helper.fill_with_base_tile(surface, left_top)
        
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

    local radius = math.abs(math.min(center.x - positions[1].x * config.grid_size, (config.grid_size * #positions) - center.x + positions[1].x * config.grid_size, center.y - positions[1].y * config.grid_size, (config.grid_size * #positions) - center.y + positions[1].y * config.grid_size) * 0.5)

    for _, position in pairs(positions) do
        local left_top = { x = position.x * config.grid_size, y = position.y * config.grid_size }

        filler_helper.fill_with_base_tile(surface, left_top)

        map_functions.draw_spreaded_rocks_around(left_top, surface, false)
        map_functions.draw_spreaded_trees_around(position, surface, false)
    end

    local distance_to_center = math.sqrt(center.x ^ 2 + center.y ^ 2)
    local max_distance = math.sqrt((config.grid_size * 0.5) ^ 2 + (config.grid_size * 0.5) ^ 2)
    local scaling_factor = math.exp(distance_to_center / (max_distance * 30)) * 13

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

    local radius = math.abs(math.min(center.x - positions[1].x * config.grid_size, (config.grid_size * #positions) - center.x + positions[1].x * config.grid_size, center.y - positions[1].y * config.grid_size, (config.grid_size * #positions) - center.y + positions[1].y * config.grid_size) * 0.5)

    for _, position in pairs(positions) do
        local left_top = { x = position.x * config.grid_size, y = position.y * config.grid_size }

        filler_helper.fill_with_base_tile(surface, left_top)

        map_functions.draw_spreaded_rocks_around(left_top, surface, false)
        map_functions.draw_spreaded_trees_around(position, surface, false)
    end

    map_functions.draw_noise_tile_circle(center, 'water', surface, radius)
    map_functions.spawn_fish(center, surface, radius)
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
    for _, offset in pairs(variant1x2.get_offsets(position, direction)) do
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
    for _, offset_pos in pairs(offset) do
        local cell = global.map_cells[utils.coord_to_string({ offset_pos.x, offset_pos.y })]

        if cell and cell.visited then return false end
    end

    return true
end

--- Get a list of positions where the room can be expanded. If multiple positions are available, set will be chosen randomly.
--- @param position table - Left top corner of the first cell for the new room
--- @param direction defines.direction - Direction in which the room will be placed
--- @return table
variant1x2.get_random_expandable_positions = function (position, direction)
    local available_positions = {}
    
    for _, offset in pairs(variant1x2.get_offsets(position, direction)) do
        local expandable_positions = {}
        for _, offset_pos in pairs(offset) do
            if variant1x2.can_expand(offset_pos, direction) then
                table.insert(expandable_positions, offset_pos)
            else
                expandable_positions = {}
                break
            end
        end
        
        if #expandable_positions > 0 then
            table.insert(available_positions, expandable_positions)
        end
    end

    if #available_positions == 0 then return { position } end
    
    return available_positions[math.random(1, #available_positions)]
end

--- Get a list of offsets where the room can be expanded.
--- @param position table - Left top corner of the first cell for the new room
--- @param direction defines.direction - Direction in which the room will be placed
--- @return table
variant1x2.get_offsets = function (position, direction)
    local offsets = {}

    local directions = {
        [defines.direction.north] = {{  1,  0 }, { -1,  0 }, {  0, -1 }},
        [defines.direction.south] = {{  1,  0 }, { -1,  0 }, {  0,  1 }},
        [defines.direction.east]  = {{  0, -1 }, {  0,  1 }, {  1,  0 }},
        [defines.direction.west]  = {{  0, -1 }, {  0,  1 }, { -1,  0 }}
    }

    for _, offset in pairs(directions[direction]) do
        local temp = {}
        table.insert(temp, { x = position.x, y = position.y })
        table.insert(temp, { x = position.x + offset[1], y = position.y + offset[2] })
        table.insert(offsets, temp)
    end

    return offsets
end

return variant1x2