local config = require('core.config.config')

local function fill_with_base_tile(surface, cell_left_top)
    for x = 0.5, config.grid_size - 0.5, 1 do
        for y = 0.5, config.grid_size - 0.5, 1 do
            local pos = { cell_left_top.x + x, cell_left_top.y + y }

            surface.set_tiles({ { name = config.base_tile, position = pos } }, true)
        end
    end
end

local filler_helper = {
    fill_with_base_tile = fill_with_base_tile;
}

return filler_helper;