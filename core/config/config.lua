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
    }
}

return config;
