local utils = require('core.utils.utils')
local Constants = require('core.utils.constants')
local Functions = require('core.utils.functions')


local market = {}

--- @param position Table|Tuple
--- @return nil
market.build = function(position)
    local surface = game.surfaces.nauvis
    local market = surface.create_entity({ name = 'market', position = position, force = 'player' })

    market.destructible = false
    market.minable = false

    market.add_market_item { 
        price = { { "coin", utils.generate_pickaxe_tier_price(1) } }, 
        offer = {
            type = 'nothing',
            effect_description = {'message.pickaxe-upgrade-to-next-tier'},
        } 
    }
    market.add_market_item { 
        price = { { "coin", utils.generate_backpack_tier_price(1) } }, 
        offer = {
            type = 'nothing',
            effect_description = {'message.backpack-upgrade-to-next-tier'}
        }
    }

    for _, item in pairs(global.config.spawn_market_items) do
        market.add_market_item(item)
    end
end

--- Special slots in the market where proper functionality is needed
--- @type table<number, function<Market, Player>>
local special_slots = {
    [1] = function(market, player)
        local pickaxe_tiers = Constants.pickaxe_tiers
        local tier = global.player_stats[player.index].pickaxe_tier + 1
        if pickaxe_tiers[tier] then
            local price = utils.generate_pickaxe_tier_price(tier)

            market.add_market_item { price = { { "coin", price } }, offer = {
                type = 'nothing',
                effect_description = {'message.pickaxe-upgrade-to-next-tier'}
            } }
        else
            market.add_market_item { price = { { "coin", 999999999 } }, offer = {
                type = 'nothing',
                effect_description = {'message.max-tier-reached'}
            } }
        end
    end,
    [2] = function(market, player)
        local tier = player.character_inventory_slots_bonus + 1
        local price = utils.generate_backpack_tier_price(tier)
        
        market.add_market_item { price = { { "coin", price } }, offer = {
            type = 'nothing',
            effect_description = {'message.backpack-upgrade-to-next-tier'}
        } }
    end,
}

--- Refreshes the market offer
--- @param market Market
--- @param player Player
--- @param slot number
--- @return nil
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

--- On market item purchased.
--- @param event MarketEvent
--- @return nil
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

    if offer_index == 1 and Constants.pickaxe_tiers[global.player_stats[event.player_index].pickaxe_tier + 1] then
        m.force.play_sound({ path = 'utility/new_objective', volume_modifier = 0.75 })

        global.player_stats[event.player_index].pickaxe_tier = global.player_stats[event.player_index].pickaxe_tier + 1

        Functions.set_mining_speed(player, player.force)

        market.refresh_offer(m, player, offer_index)

        player.print({"message.pickaxe-upgrade", Constants.pickaxe_tiers[global.player_stats[event.player_index].pickaxe_tier]})

        if not Constants.pickaxe_tiers[global.player_stats[event.player_index].pickaxe_tier + 2] then
            player.print({"message.pickaxe-max-tier"})
        end
    elseif offer_index == 2 then
        local tier = player.character_inventory_slots_bonus + 1

        m.force.play_sound({ path = 'utility/new_objective', volume_modifier = 0.75 })

        Functions.set_inventory_slot_bonus(player, tier)

        market.refresh_offer(m, player, offer_index)
        
        player.print({"message.backpack-upgrade", tier})
    end
end

return market
