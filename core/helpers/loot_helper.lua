local config = require('core.config.config')

local loot_helper = {}

--- Returns a random loot item list from the loot table.
--- @return table
loot_helper.get_loot_raffle = function ()
    local amount_of_items = 8

    local loot_raffle = {}

    for _, t in pairs(config.loot_item_raffle) do
        for x = 1, t.weight, 1 do
            if t.evolution_min <= game.forces.enemy.evolution_factor and t.evolution_max >= game.forces.enemy.evolution_factor then
                table.insert(loot_raffle, t[1])
            end
        end
    end

    local loot = {}

    for i = 1, amount_of_items, 1 do
        local item = loot_raffle[math.random(1, #loot_raffle)]
        table.insert(loot, item)
    end

    return loot
end

--- Spawns a chest with random loot items.
--- @param position Position
--- @return nil
loot_helper.spawn_chest_with_items = function (position)
    local chest = game.surfaces[1].create_entity({
        name = 'steel-chest',
        position = position,
        force = 'neutral'
    })

    local loot_raffle = loot_helper.get_loot_raffle()

    for _, item in ipairs(loot_raffle) do
        chest.insert({name = item.name, count = item.count})
    end
end

return loot_helper