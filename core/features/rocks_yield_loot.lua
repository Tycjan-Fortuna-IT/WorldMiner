local rocks_yield_loot = {}


--- Event handler for when a tree is mined.
--- @param event LuaEvent event.
--- @return nil
rocks_yield_loot.on_player_mined_entity = function(event)
    if settings.startup["rocks-yield-loot"].value == false then return end

    return
    
    -- local entity = event.entity

    -- if not config.rock_yield[entity.name] then return end

    -- if math.random(1, 50) == 1 then
    --     loot_helper.spawn_chest_with_items(entity.position)
    -- end
end

return rocks_yield_loot