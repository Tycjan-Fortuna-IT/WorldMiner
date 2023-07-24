local simplex_noise = require('core.utils.simplex_noise')
local config = require('core.config.config')
local get_noise = require('core.utils.noise')
local filler_helper = require('core.helpers.filler_helper')

simplex_noise = simplex_noise.d2
local f = {}
local math_random = math.random
local insert = table.insert

-- Draws a circle of tiles with noise variation around the given position on the surface.
-- The tiles are set based on a combination of simplex noise to create an irregular shape.
-- @param position {LuaPosition}: The center position of the circle.
-- @param name {string}: The name of the tile to draw.
-- @param surface {LuaSurface}: The surface to draw the circle on.
-- @param radius {number}: The radius of the circle in tiles.
f.draw_noise_tile_circle = function(position, name, surface, radius)
    if not position then
        return
    end
    if not name then
        return
    end
    if not surface then
        return
    end
    if not radius then
        return
    end
    local noise_seed_add = 25000
    local tiles = {}
    for y = radius * -2, radius * 2, 1 do
        for x = radius * -2, radius * 2, 1 do
            local pos = { x = x + position.x, y = y + position.y }
            local seed = game.surfaces[1].map_gen_settings.seed
            local noise_1 = simplex_noise(pos.x * 0.05, pos.y * 0.05, seed)
            seed = seed + noise_seed_add
            local noise_2 = simplex_noise(pos.x * 0.1, pos.y * 0.1, seed)
            local noise = noise_1 + noise_2 * 0.5
            local distance_to_center = math.sqrt(x ^ 2 + y ^ 2)
            if distance_to_center + noise * radius * 0.3 < radius then
                insert(tiles, { name = name, position = pos })
            end
        end
    end
    surface.set_tiles(tiles, true)
end

-- Draws an irregular-shaped ore deposit with noise variation around the given position on the surface.
-- The ore deposit shape is created using a combination of simplex noise for a more natural appearance.
-- @param position {LuaPosition}: The center position of the ore deposit.
-- @param name {string}: The name of the ore entity to draw (e.g., "iron-ore").
-- @param surface {LuaSurface}: The surface to draw the ore deposit on.
-- @param radius {number}: The radius of the ore deposit in tiles.
-- @param richness {number}: The richness value of the ore deposit.
-- @param amplitude {number}: Optional. The amplitude of the simplex noise variation. Default is 0.2.
-- @param frequency {number}: Optional. The frequency of the simplex noise variation. Default is 0.1.
f.draw_irregular_noise_ore_deposit = function(position, name, surface, radius, richness, amplitude, frequency)
    if not position or not name or not surface or not radius or not richness then
        return
    end

    local amplitude = amplitude or 0.2
    local frequency = frequency or 0.1
    local noise_seed_add = 25000
    local richness_part = richness / radius

    for y = radius * -2, radius * 2, 1 do
        for x = radius * -2, radius * 2, 1 do
            local pos = { x = x + position.x, y = y + position.y }
            local seed = game.surfaces[1].map_gen_settings.seed
            local noise_1 = simplex_noise(pos.x * frequency, pos.y * frequency, seed)
            seed = seed + noise_seed_add
            local noise_2 = simplex_noise(pos.x * frequency * 2, pos.y * frequency * 2, seed)
            local noise = noise_1 + noise_2 * amplitude

            local distance_to_center = math.sqrt(x ^ 2 + y ^ 2)
            local a = richness - richness_part * distance_to_center
            if distance_to_center + ((1 + noise) * 3) < radius and a > 1 then
                if surface.can_place_entity({ name = name, position = pos, amount = a }) then
                    surface.create_entity { name = name, position = pos, amount = a }
                end
            end
        end
    end
end

f.draw_spreaded_rocks_around = function (cell_left_top, surface, override)
    local seed = game.surfaces[1].map_gen_settings.seed

    local discovered_cells = global.discovered_cells or 0
    local rocks_spawn_probability = math.min(discovered_cells / 30, 1)

    for x = 0.5, config.grid_size - 0.5, 1 do
        for y = 0.5, config.grid_size - 0.5, 1 do
            local pos = { cell_left_top.x + x, cell_left_top.y + y }

            local noise = get_noise('stone', pos, seed)

            if math.random(1, 3) ~= 1 and math.random() <= rocks_spawn_probability and noise > 0.2 then
                local rock_entity = {
                    name = config.rock_raffle[math.random(1, #config.rock_raffle)],
                    position = pos,
                    force = 'neutral'
                }

                if override then
                    surface.create_entity(rock_entity)
                elseif surface.can_place_entity(rock_entity) then
                    surface.create_entity(rock_entity)
                end
            end
        end
    end
end

f.draw_spreaded_trees_around = function (cell_left_top, surface, override)
    local tree = config.tree_raffle[math.random(1, #config.tree_raffle)]
    local left_top = { x = cell_left_top.x * config.grid_size, y = cell_left_top.y * config.grid_size }
    local seed = math.random(1000, 1000000)

    filler_helper.fill_with_base_tile(surface, left_top)

    local discovered_cells = global.discovered_cells or 0
    local tree_spawn_probability = math.min(discovered_cells / 20, 1)

    for x = 0.5, config.grid_size - 0.5, 1 do
        for y = 0.5, config.grid_size - 0.5, 1 do
            local pos = { left_top.x + x, left_top.y + y }

            local noise = get_noise('tree', pos, seed)

            if math.random(1, 3) == 1 and math.random() <= tree_spawn_probability and  noise < -0.25 then
                surface.create_entity({ name = tree, position = pos, force = 'neutral' })
            end
        end
    end
end

return f
