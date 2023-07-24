local get_noise = require('core.utils.noise')
local config = require('core.config.config')
local map_functions = require('core.utils.map_functions')
local filler_helper = require('core.helpers.filler_helper')
local utils = require('core.utils.utils')
local functions = require('core.utils.functions')
local room = {}

require('core.utils.table')

room.init = function()
    -- TODO make it more random i guess (guaranteed_at is a bit weird)
    room.room_weights = {
        { func = room.tons_of_rocks, weight = 100, min_discovered_rooms = 0,  guaranteed_at = { 1 } },
        { func = room.tons_of_trees, weight = 34,  min_discovered_rooms = 1,  guaranteed_at = { 3 } },
        { func = room.pond,          weight = 9,   min_discovered_rooms = 5,  guaranteed_at = { 2 } },
        { func = room.ore_deposit,   weight = 6,   min_discovered_rooms = 10, guaranteed_at = { 5 } },
        { func = room.nests,         weight = 4,   min_discovered_rooms = 10, guaranteed_at = { 6 } },
        { func = room.oil,           weight = 1,   min_discovered_rooms = 10, guaranteed_at = { 12, 22, 30 } },
    }
end

room.tons_of_rocks = function(surface, cell_left_top, direction)
    local left_top = { x = cell_left_top.x * config.grid_size, y = cell_left_top.y * config.grid_size }

    filler_helper.fill_with_base_tile(surface, left_top)

    map_functions.draw_spreaded_rocks_around(left_top, surface, true)
end


room.tons_of_trees = function(surface, cell_left_top, direction)
    map_functions.draw_spreaded_trees_around(cell_left_top, surface, true)
end

room.oil = function(surface, cell_left_top, direction)
    local num_of_oils = 3 + math.floor(global.discovered_cells / 100)
    local left_top = { x = cell_left_top.x * config.grid_size, y = cell_left_top.y * config.grid_size }

    local fluids = utils.select_fluids_not_yet_placed(config.fluid_raffle)

    local fluid

    if next(fluids) ~= nil then
        fluid = utils.select_random_element_from_table_by_weight(fluids)

        global.fluids_placed[fluid.name] = true
    else
        fluid = utils.select_random_element_from_table_by_weight(config.fluid_raffle)
    end

    filler_helper.fill_with_base_tile(surface, left_top)

    local square_size = 9

    for i = 1, num_of_oils do
        local center_x = left_top.x + config.grid_size * 0.5
        local center_y = left_top.y + config.grid_size * 0.5

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
    map_functions.draw_spreaded_trees_around(cell_left_top, surface, false)
end

room.ore_deposit = function(surface, cell_left_top, direction)
    local ore_name = utils.select_random_first_element_from_tuple_by_weight(config.ore_raffle)
    local left_top = { x = cell_left_top.x * config.grid_size, y = cell_left_top.y * config.grid_size }

    filler_helper.fill_with_base_tile(surface, left_top)

    local center_x = left_top.x + config.grid_size * 0.5
    local center_y = left_top.y + config.grid_size * 0.5

    local distance_to_center = math.sqrt(center_x ^ 2 + center_y ^ 2)
    local max_distance = math.sqrt((config.grid_size * 0.5) ^ 2 + (config.grid_size * 0.5) ^ 2)
    local scaling_factor = math.exp(distance_to_center / (max_distance * 30)) * 3

    map_functions.draw_irregular_noise_ore_deposit(
        { x = left_top.x + config.grid_size * 0.5, y = left_top.y + config.grid_size * 0.5 }, ore_name, surface,
        config.grid_size * 0.3, 1968 * scaling_factor, 0.2, 0.1)

    map_functions.draw_spreaded_rocks_around(left_top, surface, false)
    map_functions.draw_spreaded_trees_around(cell_left_top, surface, false)
end

room.pond = function(surface, cell_left_top, direction)
    local tree = config.tree_raffle[math.random(1, #config.tree_raffle)]
    local left_top = { x = cell_left_top.x * config.grid_size, y = cell_left_top.y * config.grid_size }

    filler_helper.fill_with_base_tile(surface, left_top)

    map_functions.draw_noise_tile_circle(
        { x = left_top.x + config.grid_size * 0.5, y = left_top.y + config.grid_size * 0.5 }, 'water', surface,
        config.grid_size * 0.3)

    for x = 0.5, config.grid_size - 0.5, 1 do
        for y = 0.5, config.grid_size - 0.5, 1 do
            local pos = { left_top.x + x, left_top.y + y }

            if math.random(1, 16) == 1 then
                if surface.can_place_entity({ name = 'fish', position = pos, force = 'neutral' }) then
                    surface.create_entity({ name = 'fish', position = pos, force = 'neutral' })
                end
            end
            if math.random(1, 40) == 1 then
                if surface.can_place_entity({ name = tree, position = pos, force = 'neutral' }) then
                    surface.create_entity({ name = tree, position = pos, force = 'neutral' })
                end
            end
        end
    end
end

room.nests = function(surface, cell_left_top, direction)
    local amount = math.ceil(functions.get_biter_amount() * 0.1)
    local tile_positions = {}
    local left_top = { x = cell_left_top.x * config.grid_size, y = cell_left_top.y * config.grid_size }

    for x = 0.5, config.grid_size - 0.5, 1 do
        for y = 0.5, config.grid_size - 0.5, 1 do
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
    map_functions.draw_spreaded_trees_around(cell_left_top, surface, false)
end

return room
