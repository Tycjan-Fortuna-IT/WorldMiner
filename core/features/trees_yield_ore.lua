local trees_yield_ore = {}

--- Get the amount of ore to yield from a tree.
--- @param entity LuaEntity tree entity.
--- @return number amount of ore to yield.
trees_yield_ore.get_amount = function (entity)
    local distance_to_center = math.floor(math.sqrt(entity.position.x ^ 2 + entity.position.y ^ 2))
    local amount = global.rocks_yield_ore_base_amount + (distance_to_center * global.rocks_yield_ore_distance_modifier)

    if amount > global.rocks_yield_ore_maximum_amount then
        amount = global.rocks_yield_ore_maximum_amount
    end

    local m = (26 + math.random(0, 60)) * 0.01

    amount = math.floor(amount * m)
    if amount < 1 then
        amount = 1
    end

    return amount
end

--- Event handler for when a tree is mined.
--- @param event LuaEvent event.
--- @return nil
trees_yield_ore.on_player_mined_entity = function(event)
    if settings.startup["trees-yield-ore"].value == false then return end
    
    local entity = event.entity

    if entity.type ~= "tree" then return end

    if event.buffer then
        event.buffer.clear()
    end

    local amount = trees_yield_ore.get_amount(entity)
    local second_item_amount = math.random(2, 5)
    local second_item = 'wood'

    local main_item = global.rocks_yield_ore['raffle'][math.random(1, global.rocks_yield_ore['size_of_raffle'])]

    entity.surface.create_entity(
        {
            name = 'flying-text',
            position = entity.position,
            text = '+' .. amount .. ' [item=' .. main_item .. '] +' .. second_item_amount .. ' [item=' .. second_item .. ']',
            color = {r = 0.8, g = 0.8, b = 0.8}
        }
    )

    global.rocks_yield_ore['ores_mined'] = global.rocks_yield_ore['ores_mined'] + amount

    local player = game.players[event.player_index]

    local inserted_count = player.insert({name = main_item, count = amount})
    amount = amount - inserted_count
    if amount > 0 then
        entity.surface.spill_item_stack(entity.position, {name = main_item, count = amount}, true)
    end

    local inserted_count = player.insert({name = second_item, count = second_item_amount})
    second_item_amount = second_item_amount - inserted_count
    if second_item_amount > 0 then
        entity.surface.spill_item_stack(entity.position, {name = second_item, count = second_item_amount}, true)
    end
end

return trees_yield_ore