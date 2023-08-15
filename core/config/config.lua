local C = require("core.utils.constants") 

local config = {
    grid_size = 32, -- should be even
    spawn_dome_size = 10000,
    base_tile = 'grass-1',
    void_tile = 'out-of-map',
    rock_raffle = { 'rock-huge', 'rock-big', 'rock-big', 'sand-rock-big' },
    tree_raffle = { 'tree-01', 'tree-02', 'tree-03', 'tree-04', 'tree-05', 'tree-06', 'tree-07',
        'tree-08', 'tree-09', 'tree-02-red', 'tree-08-red', 'tree-09-red'
        -- 'dead-dry-hairy-tree', 'dry-hairy-tree', 'tree-09-brown'
        -- 'dry-tree', 'dead-tree-desert', 'dead-grey-trunk', 'tree-06-brown', 'tree-08-brown',
    },
    ore_raffle = {},
    fluid_raffle = {},
    spawn_market_items = {},
    loot_item_raffle = {},

    rock_yield = {
        ['rock-big'] = 1,
        ['rock-huge'] = 2,
        ['sand-rock-big'] = 1
    },

    banner_raffle = {
        'white-banner',
        'gray-banner',
        'blue-banner',
        'yellow-banner',
        'orange-banner',
        'green-banner',
        'purple-banner',
        'red-banner',
        'black-banner'
    }
}

config.on_init = function ()
    global.config = config

    config.ore_raffle = {}
    config.fluid_raffle = {}

    local base_ore_raffle = {
        { 'iron-ore',    10 },
        { 'copper-ore',  7 },
        { 'coal',        5 },
        { 'uranium-ore', 2 },
    }

    local base_fluid_raffle = {
        { name = 'crude-oil', weight = 1, scale = 100 },
    }

    local base_spawn_market_items = {
        { price = { { 'iron-ore', 200 } }, offer = { type = 'give-item', item = 'blue-coin', count = 1 } },
        { price = { { 'copper-ore', 200 } }, offer = { type = 'give-item', item = 'blue-coin', count = 1 } },
        { price = { { 'coal', 200 } }, offer = { type = 'give-item', item = 'blue-coin', count = 1 } },
        { price = { { 'uranium-ore', 200 } }, offer = { type = 'give-item', item = 'blue-coin', count = 2 } },
        { price = { { 'stone', 200 } }, offer = { type = 'give-item', item = 'blue-coin', count = 1 } },
        
        { price = { { 'blue-coin', 2 } }, offer = { type = 'give-item', item = 'iron-ore', count = 200 } },
        { price = { { 'blue-coin', 2 } }, offer = { type = 'give-item', item = 'copper-ore', count = 200 } },
        { price = { { 'blue-coin', 2 } }, offer = { type = 'give-item', item = 'coal', count = 200 } },
        { price = { { 'blue-coin', 2 } }, offer = { type = 'give-item', item = 'uranium-ore', count = 100 } },
        { price = { { 'blue-coin', 2 } }, offer = { type = 'give-item', item = 'stone', count = 200 } },
    }

    local angels_ore_raffle = {
        { 'angels-ore1', 1 },
        { 'angels-ore2', 1 },
        { 'angels-ore3', 1 },
        { 'angels-ore4', 1 },
        { 'angels-ore5', 1 },
        { 'angels-ore6', 1 },
        { 'coal',        2 },
    }

    -- name, weight, amount scale
    local angels_fluid_raffle = {
        { name = 'crude-oil',          weight = 3, scale = 100 },
        { name = 'angels-natural-gas', weight = 2, scale = 1 },
        { name = 'angels-fissure',     weight = 1, scale = 1 },
    }

    local angels_spawn_market_items = {
        { price = { { 'angels-ore1', 200 } }, offer = { type = 'give-item', item = 'blue-coin', count = 1 } },
        { price = { { 'angels-ore2', 200 } }, offer = { type = 'give-item', item = 'blue-coin', count = 1 } },
        { price = { { 'angels-ore3', 200 } }, offer = { type = 'give-item', item = 'blue-coin', count = 1 } },
        { price = { { 'angels-ore4', 200 } }, offer = { type = 'give-item', item = 'blue-coin', count = 1 } },
        { price = { { 'angels-ore5', 200 } }, offer = { type = 'give-item', item = 'blue-coin', count = 1 } },
        { price = { { 'angels-ore6', 200 } }, offer = { type = 'give-item', item = 'blue-coin', count = 1 } },
        { price = { { 'coal', 200 } }, offer = { type = 'give-item', item = 'blue-coin', count = 1 } },
        
        { price = { { 'blue-coin', 2 } }, offer = { type = 'give-item', item = 'angels-ore1', count = 200 } },
        { price = { { 'blue-coin', 2 } }, offer = { type = 'give-item', item = 'angels-ore2', count = 200 } },
        { price = { { 'blue-coin', 2 } }, offer = { type = 'give-item', item = 'angels-ore3', count = 200 } },
        { price = { { 'blue-coin', 2 } }, offer = { type = 'give-item', item = 'angels-ore4', count = 200 } },
        { price = { { 'blue-coin', 2 } }, offer = { type = 'give-item', item = 'angels-ore5', count = 200 } },
        { price = { { 'blue-coin', 2 } }, offer = { type = 'give-item', item = 'angels-ore6', count = 200 } },
        { price = { { 'blue-coin', 2 } }, offer = { type = 'give-item', item = 'coal', count = 200 } },
    }

    -- Check if angels exists and use appropriate raffle tables
    local angels_ore_exists = game.entity_prototypes['angels-ore1']

    local ore_raffle_to_use = angels_ore_exists and angels_ore_raffle or base_ore_raffle
    local fluid_raffle_to_use = angels_ore_exists and angels_fluid_raffle or base_fluid_raffle
    local spawn_market_items_to_use = angels_ore_exists and angels_spawn_market_items or base_spawn_market_items
    local loot_item_raffle_to_use = angels_ore_exists and {} or C.base_loot_item_raffle()

    for _, ore in ipairs(ore_raffle_to_use) do
        table.insert(config.ore_raffle, ore)
    end

    for _, fluid in ipairs(fluid_raffle_to_use) do
        table.insert(config.fluid_raffle, fluid)
    end

    for _, offer in ipairs(spawn_market_items_to_use) do
        table.insert(config.spawn_market_items, offer)
    end

    for _, item in ipairs(loot_item_raffle_to_use) do
        table.insert(config.loot_item_raffle, item)
    end
end

return config;
