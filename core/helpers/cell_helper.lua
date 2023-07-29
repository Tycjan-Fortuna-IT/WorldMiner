local utils = require("core.utils.utils")
local config = require("core.config.config")
local variant_dispather = require("core.variants.variant_dispatcher")


--- Draw a cell by its coordinates
--- @param cell_coords table - Coordinates of the cell
--- @param direction defines.direction - Direciton in which the cell will being drawn
--- @return nil
local function draw_cell_by_coords(cell_coords, direction)
    local surface = game.surfaces.nauvis

    if global.map_cells[utils.coord_to_string(cell_coords)] then
        if global.map_cells[utils.coord_to_string(cell_coords)].visited then
            return
        end
    end

    variant_dispather.place_random_variant(surface, { x = cell_coords.x, y = cell_coords.y }, direction)

    global.discovered_cells = global.discovered_cells + 1
end

local function draw_starting_cell(surface, left_top)
    for x = 0, config.grid_size - 1, 1 do
        for y = 0, config.grid_size - 1, 1 do
            local tile_name = config.void_tile

            if x < config.grid_size and y < config.grid_size then
                tile_name = config.base_tile
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

    game.print('Expore world chunk by chunk, mine rock for resources/coins, and build your factory!', {r = 255, g = 255, b = 50})
    game.print('You will find chunks with rocks, trees, water, oil, ore veins, enemies and many more! ...', {r = 255, g = 255, b = 50})

    variant_dispather.init()
end


local cell_helper = {
    draw_cell_by_coords = draw_cell_by_coords,
    draw_starting_cell = draw_starting_cell,
}

return cell_helper
