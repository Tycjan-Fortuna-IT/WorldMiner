local config = require('core.config.config')
local map_config = require("core.config.config")

local function fill_with_base_tile(surface, cell_left_top)
    local tiles = {}

    for x = 0, config.grid_size - 1, 1 do
        for y = 0, config.grid_size - 1, 1 do
            local pos = { cell_left_top.x + x, cell_left_top.y + y }

            tiles[#tiles + 1] = { name = map_config.base_tile, position = pos }
        end
    end

    surface.set_tiles(tiles)
end

local filler_helper = {
    fill_with_base_tile = fill_with_base_tile;
}

return filler_helper;