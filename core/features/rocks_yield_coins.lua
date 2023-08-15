local coin_yield = {
    ['rock-big'] = 1,
    ['rock-huge'] = 2,
    ['sand-rock-big'] = 1
}


local rocks_yield_coins = {}

--- On player mined entity. If the entity is a rock, it will yield coins.
--- @param event OnPlayerMinedEntityEvent
rocks_yield_coins.on_player_mined_entity = function (event)
    if coin_yield[event.entity.name] then
        local amount = math.random(math.ceil(coin_yield[event.entity.name] * 0.5), math.ceil(coin_yield[event.entity.name] * 3))

        event.entity.surface.spill_item_stack(
            event.entity.position,
            {name = 'coin', count = amount},
            true
        )

        local text_pos = { event.entity.position.x + 1.25, event.entity.position.y }

        event.entity.surface.create_entity({name = 'flying-text', position = text_pos, text = '+' .. amount .. ' [img=item/coin]', color = {r = 200, g = 160, b = 30}})
    
        event.entity.surface.create_entity(
            {
                name = 'flying-text',
                position = text_pos,
                text = '+' .. amount .. ' [img=item/coin]',
                color = {r = 200, g = 160, b = 30}
            }
        )
    end
end

return rocks_yield_coins