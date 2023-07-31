local config = require('core.config.config')
local map_functions = require('core.utils.map_functions')
local filler_helper = require('core.helpers.filler_helper')
local utils = require('core.utils.utils')
require('core.utils.table')


---@class VariantDungeon
---@field rooms Room[] Table of rooms.
local variant_dungeon = {}


--- Initialize the variant dispatcher, initialaze all rooms
--- @return nil
variant_dungeon.init = function()
    -- TODO make it more random i guess (guaranteed_at and dungeon_at is a bit weird)
    -- func - callback function responsible for creating given room
    -- Weight - increasing the weight will increase the chance of the variant being used
    -- Min discovered rooms - minimum number of TOTAL discovered rooms OF GIVEN VARIANT(not total of all variants) required for the variant to be available
    -- Max discovered rooms - maximum number of TOTAL discovered rooms OF GIVEN VARIANT(not total of all variants) allowed for the variant to be available or 0 for unlimited
    -- Guaranteed at - levels at which the variant is guaranteed to be used
    variant_dungeon.rooms = {
        { func = variant_dungeon.tons_of_rocks, weight = 1, min_discovered_rooms = 0,  max_discovered_rooms = 0, guaranteed_at = { } },
    }
end

--- Initialize the cells of the room
--- @param positions table - Table of positions as a coords of left top corner of the chunk (room)
--- @return nil
variant_dungeon.init_cell = function(positions)
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
variant_dungeon.tons_of_rocks = function(surface, positions)
    local left_top = { x = positions[1].x * config.grid_size, y = positions[1].y * config.grid_size }

    filler_helper.fill_with_base_tile(surface, left_top)

    surface.create_entity({ 
        name = 'dungeon-entrance', 
        position = { left_top.x + math.random(4, config.grid_size - 4), left_top.y + math.random(4, config.grid_size - 4) } 
    })
   
    map_functions.draw_spreaded_rocks_around(left_top, surface, false)
    map_functions.draw_spreaded_trees_around(positions[1], surface, false)
end

--- Check if available room can be placed at a given position at a given direction.
--- @param position table - Left top corner of the first cell for the new room
--- @param direction defines.direction - Direction in which the room will be placed
--- @return boolean
variant_dungeon.can_expand = function (position, direction)
    -- 1x1 variant has no restrictions
    return true
end

--- Get a list of positions where the room can be expanded. If multiple positions are available, set will be chosen randomly.
--- @param position table - Left top corner of the first cell for the new room
--- @param direction defines.direction - Direction in which the room will be placed
--- @return table
variant_dungeon.get_random_expandable_positions = function (position, direction)
    -- 1x1 variant has no multiple positions
    return { position }
end

return variant_dungeon
