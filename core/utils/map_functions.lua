local simplex_noise = require('core.utils.simplex_noise')
local get_noise = require('core.utils.noise')
local lua = require('core.utils.lua')
simplex_noise = simplex_noise.d2


local f = {}

--- Draws a circle of tiles with noise variation around the given position on the surface.
--- The tiles are set based on a combination of simplex noise to create an irregular shape.
--- @param position LuaPosition: The center position of the circle.
--- @param name string: The name of the tile to draw (e.g., "grass-1").
--- @param surface LuaSurface: The surface to draw the circle on.
--- @param radius number: The radius of the circle in tiles.
--- @return nil
f.draw_noise_tile_circle = function(position, name, surface, radius)
    if not position then return end
    if not name then return end
    if not surface then return end
    if not radius then return end

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
                table.insert(tiles, { name = name, position = pos })
            end
        end
    end

    surface.set_tiles(tiles, true)
end

--- Draws an irregular-shaped ore deposit with noise variation around the given position on the surface.
--- The ore deposit shape is created using a combination of simplex noise for a more natural appearance.
--- @param position LuaPosition: The center position of the ore deposit.
--- @param name string: The name of the ore to draw (e.g., "iron-ore").
--- @param surface LuaSurface: The surface to draw the ore deposit on.
--- @param radius number: The radius of the ore deposit in tiles.
--- @param richness number: The richness of the ore deposit.
--- @param amplitude number (optional): The amplitude of the simplex noise.
--- @param frequency number (optional): The frequency of the simplex noise.
--- @return nil
f.draw_irregular_noise_ore_deposit = function(position, name, surface, radius, richness, amplitude, frequency)
    if not position or not name or not surface or not radius or not richness then return end

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

--- Draw spreaded rocks around on the surface.
--- @param cell_left_top LuaPosition: The left top position of the cell.
--- @param surface LuaSurface: The surface to draw the rocks on.
--- @param override boolean (optional): Whether to override existing entities.
--- @return nil
f.draw_spreaded_rocks_around = function (cell_left_top, surface, override)
    local seed = game.surfaces[1].map_gen_settings.seed

    local center = { x = cell_left_top.x + global.config.grid_size * 0.5, y = cell_left_top.y + global.config.grid_size * 0.5 }    
    local distance_to_center = math.sqrt(center.x ^ 2 + center.y ^ 2)

    local rocks_spawn_probability = math.min(distance_to_center / 500, 1)

    for x = 0.5, global.config.grid_size - 0.5, 1 do
        for y = 0.5, global.config.grid_size - 0.5, 1 do
            local pos = { cell_left_top.x + x, cell_left_top.y + y }

            local noise = get_noise('stone', pos, seed)

            local generate_rock = lua.ternary(
                settings.startup["generate-more-rocks-from-start"].value, 
                math.random(1, 3) ~= 1 and (noise > 0.2 or noise < -0.2), 
                math.random(1, 3) ~= 1 and math.random() <= rocks_spawn_probability and noise > 0.2
            )

            if generate_rock then
                local rock_entity = {
                    name = global.config.rock_raffle[math.random(1, #global.config.rock_raffle)],
                    position = pos,
                    force = 'neutral'
                }

                if override then
                    surface.create_entity(rock_entity)
                elseif surface.can_place_entity(rock_entity) then
                    if math.random(1, 15) == 1 then
                        surface.create_entity(rock_entity)
                    end
                end
            end
        end
    end
end

--- Draw spreaded trees around on the surface.
--- @param cell_left_top LuaPosition: The left top position of the cell.
--- @param surface LuaSurface: The surface to draw the trees on.
--- @param override boolean (optional): Whether to override existing entities.
--- @return nil
f.draw_spreaded_trees_around = function (cell_left_top, surface, override)
    local tree = global.config.tree_raffle[math.random(1, #global.config.tree_raffle)]
    local left_top = { x = cell_left_top.x * global.config.grid_size, y = cell_left_top.y * global.config.grid_size }
    local seed = math.random(1000, 1000000)

    local discovered_cells = global.discovered_cells or 0
    local tree_spawn_probability = math.min(discovered_cells / 20, 1)

    for x = 0.5, global.config.grid_size - 0.5, 1 do
        for y = 0.5, global.config.grid_size - 0.5, 1 do
            local pos = { left_top.x + x, left_top.y + y }

            local noise = get_noise('tree', pos, seed)
            
            local generate_tree = lua.ternary(
                settings.startup["generate-more-trees-from-start"].value, 
                math.random(1, 3) == 1 and noise > 0.25 or noise < -0.25 , 
                math.random(1, 3) == 1 and math.random() <= tree_spawn_probability and noise < -0.25
            )

            local tree_entity = { 
                name = tree,
                position = pos,
                force = 'neutral'
            }

            if generate_tree then
                if override then
                    surface.create_entity(tree_entity)
                elseif surface.can_place_entity(tree_entity) then
                    surface.create_entity(tree_entity)
                end
            end
        end
    end
end

--- Spawn spreaded fishes around on the surface.
--- @param center LuaPosition: Center position.
--- @param surface LuaSurface: The surface to spawn the fishes on.
--- @param radius number: The radius of the circle in tiles.
--- @return nil
f.spawn_fish = function (center, surface, radius)
    local fish_count = math.floor(radius * 2)

    for i = 1, fish_count do
        local angle = math.random() * 2 * math.pi
        local distance = math.random() * radius
        local x = center.x + distance * math.cos(angle)
        local y = center.y + distance * math.sin(angle)
        surface.create_entity({ name = 'fish', position = { x, y } })
    end
end

--- Draw a mixed ore patch around the given position on the surface.
--- The ore patch shape is created using a combination of simplex noise for a more natural appearance.
--- @param position LuaPosition: The center position of the ore patch.
--- @param surface LuaSurface: The surface to draw the ore patch on.
--- @param radius number: The radius of the ore patch in tiles.
--- @param richness number: The richness of the ore patch.
--- @return nil
f.draw_mixed_ore_patch = function(position, surface, radius, richness)
    if not position then return end
    if not surface then return end
    if not radius then return end
    if not richness then return end

    local modifier_1 = math.random(2, 7)
    local modifier_2 = math.random(100, 200) * 0.0002
    local modifier_3 = math.random(100, 200) * 0.0015
    local modifier_4 = math.random(15, 30) * 0.01
    local seed = game.surfaces[1].map_gen_settings.seed
    local richness_part = richness / (radius * 2)
    
    local ores = {}

    for _, ore in ipairs(global.config.ore_raffle) do
        table.insert(ores, ore[1])
    end

    for y = radius * -3, radius * 3, 1 do
        for x = radius * -3, radius * 3, 1 do
            local pos = {x = x + position.x, y = y + position.y}
            local noise = simplex_noise(pos.x * modifier_2, pos.y * modifier_2, seed) + simplex_noise(pos.x * modifier_3, pos.y * modifier_3, seed) * modifier_4
            local distance_to_center = math.sqrt(x ^ 2 + y ^ 2)
            local ore = ores[(math.ceil(noise * modifier_1) % 4) + 1]
            local amount = richness - richness_part * distance_to_center
            if amount > 1 then
                if surface.can_place_entity({name = ore, position = pos, amount = amount}) then
                    if distance_to_center + (noise * radius * 0.5) < radius then
                        surface.create_entity {name = ore, position = pos, amount = amount}
                    end
                end
            end
        end
    end
end

--- Draw a circle of oil around the given position on the surface.
--- @param position LuaPosition: The center position of the oil circle.
--- @param name string: The name of the oil to draw (e.g., "crude-oil").
--- @param surface LuaSurface: The surface to draw the oil circle on.
--- @param radius number: The radius of the oil circle in tiles.
--- @param richness number: The richness of the oil circle.
--- @return nil
f.draw_oil_circle = function(position, name, surface, radius, richness)
    if not position then return end
    if not name then return end
    if not surface then return end
    if not radius then return end
    if not richness then return end

    local count = 0
    local max_count = 0

    while count < radius and max_count < 100000 do
        for y = radius * -1, radius, 1 do
            for x = radius * -1, radius, 1 do
                if math.random(1, 200) == 1 then
                    local pos = {x = x + position.x, y = y + position.y}
                    local a = math.random(richness * 0.5, richness * 1.5)
                    local distance_to_center = math.sqrt(x ^ 2 + y ^ 2)
                    if distance_to_center < radius then
                        if surface.can_place_entity({name = name, position = pos, amount = a}) then
                            surface.create_entity {name = name, position = pos, amount = a}
                            count = count + 1
                        end
                    end
                end
            end
        end
        max_count = max_count + 1
    end
end

return f
