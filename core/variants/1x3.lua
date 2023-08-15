local map_functions = require('core.utils.map_functions')
local filler_helper = require('core.helpers.filler_helper')
local utils = require('core.utils.utils')
local functions = require('core.utils.functions')


---@class Variant1x3
---@field rooms Room[] Table of rooms.
local variant1x3 = {}

--- Initialize the variant dispatcher, initialaze all rooms
--- @return nil
variant1x3.init = function()
    -- TODO make it more random i guess (guaranteed_at and dungeon_at is a bit weird)
    -- func - callback function responsible for creating given room
    -- Weight - increasing the weight will increase the chance of the variant being used
    -- Min discovered rooms - minimum number of TOTAL discovered rooms OF GIVEN VARIANT(not total of all variants) required for the variant to be available
    -- Max discovered rooms - maximum number of TOTAL discovered rooms OF GIVEN VARIANT(not total of all variants) allowed for the variant to be available or 0 for unlimited
    -- Guaranteed at - levels at which the variant is guaranteed to be used
    variant1x3.rooms = {
        { func = variant1x3.tons_of_rocks, weight = 6, min_discovered_rooms = 0,  max_discovered_rooms = 0, guaranteed_at = { 1 } },
        { func = variant1x3.tons_of_trees, weight = 4, min_discovered_rooms = 1,  max_discovered_rooms = 0, guaranteed_at = { 2 } },
        { func = variant1x3.ore_deposit_with_enemies, weight = 1, min_discovered_rooms = 2,  max_discovered_rooms = 0, guaranteed_at = { 3 } },
    }
end

--- Initialize the cells of the room
--- @param positions table - Table of positions as a coords of left top corner of the chunk (room)
--- @return nil
variant1x3.init_cell = function(positions)
    for _, position in pairs(positions) do
        local key = utils.coord_to_string({ position.x, position.y })

        global.map_cells[key] = global.map_cells[key] or {}
        global.map_cells[key].visited = true
    end

    global.discovered_cells = global.discovered_cells + 3
end

--- Create a room with tons of rocks
--- @param surface LuaSurface - Surface on which the room will be placed
--- @param positions table - Table of positions as a coords of left top corner of the chunk (room)
--- @return nil
variant1x3.tons_of_rocks = function(surface, positions)
    for _, position in pairs(positions) do
        local left_top = { x = position.x * global.config.grid_size, y = position.y * global.config.grid_size }

        filler_helper.fill_with_base_tile(surface, left_top)

        map_functions.draw_spreaded_rocks_around(left_top, surface, true)
    end
end

--- Create a room with tons of trees
--- @param surface LuaSurface - Surface on which the room will be placed
--- @param positions table - Table of positions as a coords of left top corner of the chunk (room)
--- @return nil
variant1x3.tons_of_trees = function (surface, positions)
    for _, position in pairs(positions) do
        local left_top = { x = position.x * global.config.grid_size, y = position.y * global.config.grid_size }

        filler_helper.fill_with_base_tile(surface, left_top)

        map_functions.draw_spreaded_trees_around(position, surface, true)
    end
end

--- Create a room with big ore deposit in the middle and enemies around it
--- @param surface LuaSurface - Surface on which the room will be placed
--- @param positions table - Table of positions as a coords of left top corner of the chunk (room)
--- @return nil
variant1x3.ore_deposit_with_enemies = function (surface, positions)
    local amount = math.ceil(functions.get_biter_amount() * 0.4)
    local tile_positions = {}

    for _, position in pairs(positions) do
        for x = 0.5, global.config.grid_size - 0.5, 1 do
            for y = 0.5, global.config.grid_size - 0.5, 1 do
                local pos = { position.x * global.config.grid_size + x, position.y * global.config.grid_size + y }
                tile_positions[#tile_positions + 1] = pos
            end
        end
    end

    for _, position in pairs(positions) do
        local left_top = { x = position.x * global.config.grid_size, y = position.y * global.config.grid_size }
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

    local ore_name = utils.select_random_first_element_from_tuple_by_weight(global.config.ore_raffle)
    local center = { x = 0, y = 0 }

    for _, position in pairs(positions) do
        center.x = center.x + position.x * global.config.grid_size + global.config.grid_size * 0.5
        center.y = center.y + position.y * global.config.grid_size + global.config.grid_size * 0.5
    end

    center.x = center.x / #positions
    center.y = center.y / #positions

    local radius = math.abs(math.min(center.x - positions[1].x * global.config.grid_size, (global.config.grid_size * #positions) - center.x + positions[1].x * global.config.grid_size, center.y - positions[1].y * global.config.grid_size, (global.config.grid_size * #positions) - center.y + positions[1].y * global.config.grid_size) * 0.5)

    for _, position in pairs(positions) do
        local left_top = { x = position.x * global.config.grid_size, y = position.y * global.config.grid_size }

        filler_helper.fill_with_base_tile(surface, left_top)

        map_functions.draw_spreaded_rocks_around(left_top, surface, false)
        map_functions.draw_spreaded_trees_around(position, surface, false)
    end

    local distance_to_center = math.sqrt(center.x ^ 2 + center.y ^ 2)
    local max_distance = math.sqrt((global.config.grid_size * 0.5) ^ 2 + (global.config.grid_size * 0.5) ^ 2)
    local scaling_factor = math.exp(distance_to_center / (max_distance * 30)) * 13

    map_functions.draw_irregular_noise_ore_deposit(center, ore_name, surface, radius * 2, 1968 * scaling_factor, 0.2, 0.1)
end

--- Check if available room can be placed at a given direction.
--- @param position table - Left top corner of the first cell for the new room
--- @param direction defines.direction - Direction in which the room will be placed
--- @return boolean
variant1x3.can_expand = function (position, direction)
    for _, offset in pairs(variant1x3.get_offsets(position, direction)) do
        if variant1x3.can_expand_offset(offset) then
            return true
        end
    end

    return false
end

--- Check if there is room at given offset that is position of one of the cells of the room.
--- @param offset table - Offset from the left top corner
--- @return boolean
variant1x3.can_expand_offset = function (offset)
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
variant1x3.get_random_expandable_positions = function (position, direction)
    local available_positions = {}
    
    for _, offset in pairs(variant1x3.get_offsets(position, direction)) do
        local expandable_positions = {}
        for _, offset_pos in pairs(offset) do
            if variant1x3.can_expand(offset_pos, direction) then
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
variant1x3.get_offsets = function (position, direction)
    local offsets = {}

    local directions = {
        [defines.direction.north] = {{{ 0, 1 }, { 0, 2 }}, {{ 1, 0 }, { 2, 0 }}, {{ 0, -1 }, { 0, -2 }}},
        [defines.direction.south] = {{{ 0, 1 }, { 0, 2 }}, {{ -1, 0 }, { -2, 0 }}, {{ 1, 0 }, { 2, 0 }}},
        [defines.direction.east]  = {{{ 1, 0 }, { 2, 0 }}, {{ 0, 1 }, { 0, 2 }}, {{ 0, -1 }, { 0, -2 }}},
        [defines.direction.west]  = {{{ -1, 0 }, { -2, 0 }}, {{ 0, -1 }, { 0, -2 }}, {{ 0, 1 }, { 0, 2 }}}
    }

    if not directions[direction] then
        error('Invalid direction: ' .. direction)
    end

    for _, offset in pairs(directions[direction]) do
        local temp = {}
        table.insert(temp, { x = position.x, y = position.y })
        
        for _, offset_pos in pairs(offset) do
            table.insert(temp, { x = position.x + offset_pos[1], y = position.y + offset_pos[2] })
        end

        table.insert(offsets, temp)
    end

    return offsets
end

return variant1x3