local config = {
    grid_size = 32, -- should be even
    base_tile = 'grass-1',
    void_tile = 'out-of-map',
    rock_raffle = { 'rock-huge', 'rock-big', 'rock-big', 'rock-big' },
    tree_raffle = { 'tree-01', 'tree-02', 'tree-03', 'tree-04', 'tree-05', 'tree-06', 'tree-07',
        'tree-08', 'tree-09', 'tree-02-red', 'tree-08-red', 'tree-09-red'
        -- 'dead-dry-hairy-tree', 'dry-hairy-tree', 'tree-09-brown'
        -- 'dry-tree', 'dead-tree-desert', 'dead-grey-trunk', 'tree-06-brown', 'tree-08-brown',
    },
    ore_raffle = {},
    fluid_raffle = {},
}

config.on_init = function()
    config.ore_raffle = {}
    config.fluid_raffle = {}

    local base_ore_raffle = {
        { 'iron-ore',    25 },
        { 'copper-ore',  17 },
        { 'coal',        13 },
        { 'uranium-ore', 2 },
    }

    local base_fluid_raffle = {
        { name = 'crude-oil', weight = 1, scale = 100 },
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

    -- Check if angels exists and use appropriate raffle tables
    local angels_ore_exists = game.entity_prototypes['angels-ore1']

    local ore_raffle_to_use = angels_ore_exists and angels_ore_raffle or base_ore_raffle
    local fluid_raffle_to_use = angels_ore_exists and angels_fluid_raffle or base_fluid_raffle

    for _, ore in ipairs(ore_raffle_to_use) do
        table.insert(config.ore_raffle, ore)
    end

    for _, fluid in ipairs(fluid_raffle_to_use) do
        table.insert(config.fluid_raffle, fluid)
    end
end

return config;
