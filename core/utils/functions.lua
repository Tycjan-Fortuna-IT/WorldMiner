local functions = {}

functions.set_mining_speed = function (player, force)
    force.manual_mining_speed_modifier = global.player_stats[player.index].pickaxe_tier * 0.40

    return force.manual_mining_speed_modifier
end

return functions