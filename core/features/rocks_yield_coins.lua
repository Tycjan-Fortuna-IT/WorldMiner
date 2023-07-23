local coin_yield = {
    ['rock-big'] = 1,
    ['rock-huge'] = 2,
    ['sand-rock-big'] = 1
}

local function on_player_mined_entity(event)
    if coin_yield[event.entity.name] then
        local amount = math.random(math.ceil(coin_yield[event.entity.name] * 0.5), math.ceil(coin_yield[event.entity.name] * 3))

        event.entity.surface.spill_item_stack(
            event.entity.position,
            {name = 'coin', count = amount},
            true
        )

        local text_pos = { event.entity.position.x + 1.5, event.entity.position.y }

        event.entity.surface.create_entity({name = 'flying-text', position = text_pos, text = '+' .. amount .. ' [img=item/coin]', color = {r = 200, g = 160, b = 30}})
    end
end

local rocks_yield_coins = {
    on_player_mined_entity = on_player_mined_entity
}

return rocks_yield_coins