local functions = {}

functions.set_mining_speed = function (player, force)
    force.manual_mining_speed_modifier = global.player_stats[player.index].pickaxe_tier * 0.40

    return force.manual_mining_speed_modifier
end

functions.get_biter_amount = function ()
    local average = math.ceil(1 + (global.discovered_cells * 0.3))
    
    return math.random(math.ceil(average * 0.7), math.ceil(average * 1.3))
end

return functions