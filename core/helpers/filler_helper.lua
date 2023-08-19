local filler_helper = {}

filler_helper.fill_with_base_tile = function (surface, cell_left_top)
    local tiles = {}

    for x = 0, global.config.grid_size - 1, 1 do
        for y = 0, global.config.grid_size - 1, 1 do
            local pos = { cell_left_top.x + x, cell_left_top.y + y }

            tiles[#tiles + 1] = { name = global.config.base_tile, position = pos }
        end
    end

    surface.set_tiles(tiles)
end

return filler_helper;