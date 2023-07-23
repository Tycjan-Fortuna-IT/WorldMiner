local utils = require('core.utils.utils')
local Constants = require('core.utils.constants')
local Functions = require('core.utils.functions')
local market = {}

market.build = function(position)
    local surface = game.surfaces.nauvis
    local market = surface.create_entity({ name = 'market', position = position, force = 'player' })

    market.destructible = false
    market.minable = false

    market.add_market_item { price = { { "coin", utils.generate_pickaxe_tier_price(1) } }, offer = {
        type = 'nothing',
        effect_description = 'Upgrade pickaxe to next tier'
    } }
end

local special_slots = {
    [1] = function(market, player)
        local pickaxe_tiers = Constants.pickaxe_tiers
        local tier = global.player_stats[player.index].pickaxe_tier + 1
        if pickaxe_tiers[tier] then
            local price = utils.generate_pickaxe_tier_price(tier)

            market.add_market_item { price = { { "coin", price } }, offer = {
                type = 'nothing',
                effect_description = 'Upgrade pickaxe to next tier' .. ' (' .. pickaxe_tiers[tier] .. ')'
            } }
        else
            market.add_market_item { price = { { "coin", 999999999 } }, offer = {
                type = 'nothing',
                effect_description = 'Maximum tier reached!'
            } }
        end
    end
}

market.refresh_offer = function (market, player, slot)
    local offers = market.get_market_items()

    market.clear_market_items()

    for k, offer in pairs(offers) do
        if k == slot then
            special_slots[k](market, player)
        else
            market.add_market_item(offer)
        end
    end
end

market.on_market_item_purchased = function(event)
    if not global.player_stats[event.player_index] then
        global.player_stats[event.player_index] = {}
        global.player_stats[event.player_index].pickaxe_tier = 1
    end

    local player = game.players[event.player_index]
    local m = event.market
    local offer_index = event.offer_index
    local offers = m.get_market_items()
    local bought_offer = offers[offer_index].offer

    if bought_offer.type ~= 'nothing' then
        return
    end

    local count = event.count

    if offer_index == 1 and Constants.pickaxe_tiers[global.player_stats[event.player_index].pickaxe_tier + 1] then
        m.force.play_sound({ path = 'utility/new_objective', volume_modifier = 0.75 })

        global.player_stats[event.player_index].pickaxe_tier = global.player_stats[event.player_index].pickaxe_tier + 1

        Functions.set_mining_speed(player, player.force)

        market.refresh_offer(m, player, offer_index)

        game.print('Pickaxe has been upgraded to: ' .. Constants.pickaxe_tiers[global.player_stats[event.player_index].pickaxe_tier] .. '!')
    else
        game.print('Pickaxe is at maximum tier! Further upgrades are not possible and will not do anything! Dont waste money!')
    end
end

return market
