local config = {
    grid_size = 32, -- should be even
    base_tile = 'grass-1',
    void_tile = 'out-of-map',
    rock_raffle = { 'rock-huge', 'rock-big', 'rock-big', 'rock-big' },
    tree_raffle = { 'tree-01', 'tree-02', 'tree-03', 'tree-04', 'tree-05', 'tree-06',
        'tree-07', 'tree-08', 'tree-09', 'tree-02-red', 'tree-06-brown', 'tree-08-brown',
        'tree-08-red', 'tree-09-brown', 'tree-09-red'
        -- 'dead-dry-hairy-tree', 'dry-hairy-tree',
        -- 'dry-tree', 'dead-tree-desert', 'dead-grey-trunk'
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
        { 'crude-oil', 1 },
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

    local angels_fluid_raffle = {
        { 'crude-oil',          3 },
        { 'angels-natural-gas', 2 },
        { 'angels-fissure',     1 },
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
