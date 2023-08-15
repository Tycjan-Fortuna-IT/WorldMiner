--- On player mined entity. If the entity is a rock, it can yield such enemies.
--- @type table<number, string[]>
local rock_inhabitants = {
    [1] = { 'small-biter' },
    [2] = { 'small-biter', 'small-biter', 'small-biter', 'small-biter', 'small-biter', 'medium-biter' },
    [3] = { 'small-biter', 'small-biter', 'small-biter', 'small-biter', 'medium-biter', 'medium-biter' },
    [4] = { 'small-biter', 'small-biter', 'small-biter', 'medium-biter', 'medium-biter', 'small-spitter' },
    [5] = { 'small-biter', 'small-biter', 'medium-biter', 'medium-biter', 'medium-biter', 'small-spitter' },
    [6] = { 'small-biter', 'small-biter', 'medium-biter', 'medium-biter', 'big-biter', 'small-spitter' },
    [7] = { 'small-biter', 'small-biter', 'medium-biter', 'medium-biter', 'big-biter', 'medium-spitter' },
    [8] = { 'small-biter', 'medium-biter', 'medium-biter', 'medium-biter', 'big-biter', 'medium-spitter' },
    [9] = { 'small-biter', 'medium-biter', 'medium-biter', 'big-biter', 'big-biter', 'medium-spitter' },
    [10] = { 'medium-biter', 'medium-biter', 'medium-biter', 'big-biter', 'big-biter', 'big-spitter' },
    [11] = { 'medium-biter', 'medium-biter', 'big-biter', 'big-biter', 'big-biter', 'big-spitter' },
    [12] = { 'medium-biter', 'big-biter', 'big-biter', 'big-biter', 'big-biter', 'big-spitter' },
    [13] = { 'big-biter', 'big-biter', 'big-biter', 'big-biter', 'big-biter', 'big-spitter' },
    [14] = { 'big-biter', 'big-biter', 'big-biter', 'big-biter', 'behemoth-biter', 'big-spitter' },
    [15] = { 'big-biter', 'big-biter', 'big-biter', 'behemoth-biter', 'behemoth-biter', 'big-spitter' },
    [16] = { 'big-biter', 'big-biter', 'big-biter', 'behemoth-biter', 'behemoth-biter', 'behemoth-spitter' },
    [17] = { 'big-biter', 'big-biter', 'behemoth-biter', 'behemoth-biter', 'behemoth-biter', 'behemoth-spitter' },
    [18] = { 'big-biter', 'behemoth-biter', 'behemoth-biter', 'behemoth-biter', 'behemoth-biter', 'behemoth-spitter' },
    [19] = { 'behemoth-biter', 'behemoth-biter', 'behemoth-biter', 'behemoth-biter', 'behemoth-biter', 'behemoth-spitter' },
    [20] = { 'behemoth-biter', 'behemoth-biter', 'behemoth-biter', 'behemoth-biter', 'behemoth-spitter', 'behemoth-spitter' }
}


local rocks_yield_enemies = {}

rocks_yield_enemies.on_init = function(event)

end

rocks_yield_enemies.on_configuration_changed = function(event)

end

rocks_yield_enemies.on_player_mined_entity = function(event)
    if settings.startup["rocks-yield-enemies"].value == false then return end

    local entity = event.entity

    if not global.config.rock_yield[entity.name] then
        return
    end

    if math.random(1, 10) ~= 1 then return end

    local surface = game.surfaces[1]
    local pos = { x = entity.position.x, y = entity.position.y }
    local tile_distance_to_center = math.sqrt(pos.x ^ 2 + pos.y ^ 2)
    local rock_inhabitants_index = math.ceil((tile_distance_to_center - math.sqrt(global.config.spawn_dome_size)) * 0.005, 0)

    if rock_inhabitants_index < 1 then
        rock_inhabitants_index = 1
    end

    if rock_inhabitants_index > #rock_inhabitants then
        rock_inhabitants_index = #rock_inhabitants
    end

    local enemies = rock_inhabitants[rock_inhabitants_index]

    for index, enemy_name in ipairs(enemies) do
        local p = surface.find_non_colliding_position(enemy_name, pos, 6, 0.5)
    
        if not p then return end
        
        local biter = surface.create_entity { name = enemy_name, position = p }
        local target_position = game.players[event.player_index].position
    
        if target_position then
            biter.set_command({ type = defines.command.attack_area, destination = target_position, radius = 5,
                distraction = defines.distraction.by_anything 
            })
        else
            biter.set_command({ 
                type = defines.command.attack_area, 
                destination = game.forces['player'].get_spawn_position(surface),
                radius = 5, distraction = defines.distraction.by_anything 
            })
        end
    end
end

return rocks_yield_enemies
