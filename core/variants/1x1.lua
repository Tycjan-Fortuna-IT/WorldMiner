local get_noise = require('core.utils.noise')
local config = require('core.config.config')
local map_functions = require('core.utils.map_functions')
local filler_helper = require('core.helpers.filler_helper')
local kustom_maf = require('core.utils.math')
local functions = require('core.utils.functions')
local room = {}

require('core.utils.table')

room.tons_of_rocks = function(surface, cell_left_top, direction)
    local left_top = { x = cell_left_top.x * config.grid_size, y = cell_left_top.y * config.grid_size }

    local seed = game.surfaces[1].map_gen_settings.seed

    filler_helper.fill_with_base_tile(surface, left_top)

    for x = 0.5, config.grid_size - 0.5, 1 do
        for y = 0.5, config.grid_size - 0.5, 1 do
            local pos = { left_top.x + x, left_top.y + y }

            local noise = get_noise('stone', pos, seed)

            if math.random(1, 3) ~= 1 then
                if noise > 0.2 or noise < -0.2 then
                    surface.create_entity({
                        name = config.rock_raffle[math.random(1, #config.rock_raffle)],
                        position = pos,
                        force = 'neutral'
                    })
                end
            end
        end
    end
end

room.tons_of_trees = function(surface, cell_left_top, direction)
    local tree = config.tree_raffle[math.random(1, #config.tree_raffle)]
    local left_top = { x = cell_left_top.x * config.grid_size, y = cell_left_top.y * config.grid_size }
    local seed = math.random(1000, 1000000)

    filler_helper.fill_with_base_tile(surface, left_top)

    for x = 0.5, config.grid_size - 0.5, 1 do
        for y = 0.5, config.grid_size - 0.5, 1 do
            local pos = { left_top.x + x, left_top.y + y }

            local noise = get_noise('tree', pos, seed)

            if math.random(1, 3) == 1 then
                if noise > 0.25 or noise < -0.25 then
                    surface.create_entity({ name = tree, position = pos, force = 'neutral' })
                end
            end
        end
    end
end

room.oil = function(surface, cell_left_top, direction)
    local num_of_oils = 3 + math.floor(global.discovered_cells / 100)
    local left_top = { x = cell_left_top.x * config.grid_size, y = cell_left_top.y * config.grid_size }

    local fluids = kustom_maf.select_fluids_not_yet_placed(config.fluid_raffle)

    local fluid

    if next(fluids) ~= nil then
        fluid = kustom_maf.select_random_element_from_table_by_weight(fluids)

        global.fluids_placed[fluid.name] = true
    else
        fluid = kustom_maf.select_random_element_from_table_by_weight(config.fluid_raffle)
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
                name = fluid.name,
                position = corner_position,
                amount = 10000 + global.discovered_cells * 400 * fluid.scale
            })
        end
    end
end

room.ore_deposit = function(surface, cell_left_top, direction)
    local ore_name = kustom_maf.select_random_first_element_from_tuple_by_weight(config.ore_raffle)

    local left_top = { x = cell_left_top.x * config.grid_size, y = cell_left_top.y * config.grid_size }

    filler_helper.fill_with_base_tile(surface, left_top)

    map_functions.draw_irregular_noise_ore_deposit(
        { x = left_top.x + config.grid_size * 0.5, y = left_top.y + config.grid_size * 0.5 }, ore_name, surface,
        config.grid_size * 0.3, (global.discovered_cells + 1) * 200, 0.2, 0.1)
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
end

local room_weights = {
    { func = room.tons_of_rocks, weight = 100, min_discovered_rooms = 0 },
    { func = room.tons_of_trees, weight = 34,  min_discovered_rooms = 1 },
    { func = room.pond,          weight = 9,   min_discovered_rooms = 5 },
    { func = room.ore_deposit,   weight = 6,   min_discovered_rooms = 10 },
    { func = room.nests,         weight = 4,   min_discovered_rooms = 10 },
    { func = room.oil,           weight = 2,   min_discovered_rooms = 10 },
}

return room_weights
