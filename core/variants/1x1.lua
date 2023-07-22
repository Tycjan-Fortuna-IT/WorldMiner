local get_noise = require('core.utils.noise')
local config = require('core.config.config')
local map_functions = require('core.utils.map_functions')
local filler_helper = require('core.helpers.filler_helper')
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

    filler_helper.fill_with_base_tile(surface, left_top)

    for i = 1, num_of_oils do
        local oil_position = {
            x = left_top.x + config.grid_size * (0.3 + math.random() * 0.4),
            y = left_top.y + config.grid_size * (0.3 + math.random() * 0.4)
        }

        surface.create_entity({
            name = 'crude-oil',
            position = oil_position,
            amount = 100000 + global.discovered_cells * 4000
        })
    end
end

room.ore_deposit = function(surface, cell_left_top, direction)
    local ores = { 'coal', 'iron-ore', 'copper-ore', 'stone' }
    table.shuffle_table(ores)

    local left_top = { x = cell_left_top.x * config.grid_size, y = cell_left_top.y * config.grid_size }

    filler_helper.fill_with_base_tile(surface, left_top)

    map_functions.draw_irregular_noise_ore_deposit(
        { x = left_top.x + config.grid_size * 0.5, y = left_top.y + config.grid_size * 0.5 }, ores[1], surface,
        config.grid_size * 0.3, global.discovered_cells * 97, 0.2, 0.1)
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

local room_weights = {
    { func = room.tons_of_rocks, weight = 100 },
    { func = room.tons_of_trees, weight = 34 },
    { func = room.pond,          weight = 9 },
    { func = room.ore_deposit,   weight = 4 },
    { func = room.oil,           weight = 1 },
}

return room_weights
