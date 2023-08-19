local utils = require("core.utils.utils")
local variant_dispatcher = require("core.variants.variant_dispatcher")


local cell_helper = {}

--- Draw a cell by its coordinates
--- @param cell_coords table - Coordinates of the cell
--- @param direction defines.direction - Direciton in which the cell will being drawn
--- @return nil
cell_helper.draw_cell_by_coords = function (cell_coords, direction)
    local surface = game.surfaces.nauvis

    if global.map_cells[utils.coord_to_string(cell_coords)] then
        if global.map_cells[utils.coord_to_string(cell_coords)].visited then
            return
        end
    end

    variant_dispatcher.place_random_variant(surface, { x = cell_coords.x, y = cell_coords.y }, direction)
end

cell_helper.draw_starting_cell = function (surface, left_top)
    for x = 0, global.config.grid_size - 1, 1 do
        for y = 0, global.config.grid_size - 1, 1 do
            local tile_name = global.config.void_tile

            if x < global.config.grid_size and y < global.config.grid_size then
                tile_name = global.config.base_tile
            end

            local p = { x = left_top.x + x, y = left_top.y + y }

            surface.set_tiles({ { name = tile_name, position = p } }, true)
        end
    end

    for _, e in pairs(surface.find_entities_filtered({ force = 'neutral' })) do
        e.destroy()
    end

    global.map_cells[utils.coord_to_string({ 0, 0 })] = global.map_cells[utils.coord_to_string({ 0, 0 })] or {}
    global.map_cells[utils.coord_to_string({ 0, 0 })].visited = true

    variant_dispatcher.on_init()
end

return cell_helper
