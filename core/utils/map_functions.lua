local simplex_noise = require 'core.utils.simplex_noise'
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


return f
