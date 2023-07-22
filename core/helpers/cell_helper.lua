local kustom_maf = require("core.utils.math")
local config = require("core.config.config")
local rooms1x1 = require("core.variants.1x1")

local rock_raffle = {'rock-huge', 'rock-big', 'rock-big', 'rock-big'}

local function init_cell(cell_position)
    local cell_coords = kustom_maf.coord_to_string(cell_position)

    global.map_cells[cell_coords] = global.map_cells[cell_coords] or {}
    global.map_cells[cell_coords].visited = global.map_cells[cell_coords].visited or true
end

local function draw_cell_by_coords(cell_coords)
    local surface = game.surfaces.nauvis
    
    if global.map_cells[kustom_maf.coord_to_string(cell_coords)] then
        if global.map_cells[kustom_maf.coord_to_string(cell_coords)].visited then
            return
        end
    end

    kustom_maf.select_random_by_weight(rooms1x1)(surface, {x = cell_coords[1], y = cell_coords[2]}, 0)

    init_cell(cell_coords)

    global.discovered_cells = global.discovered_cells + 1
end

local function draw_starting_cell(surface, left_top)
    for x = 0, 31, 1 do
        for y = 0, 31, 1 do
            local tile_name = config.void_tile

            if x < config.grid_size and y < config.grid_size then
                tile_name = config.base_tile
            end

            local p = {x = left_top.x + x, y = left_top.y + y}

            surface.set_tiles({{name = tile_name, position = p}}, true)
        end
    end

    for _, e in pairs(surface.find_entities_filtered({force = 'neutral'})) do
        e.destroy()
    end

    init_cell({0, 0})

    global.map_cells[kustom_maf.coord_to_string({0, 0})].visited = true

    -- Placing a small starting pond
    local water_tile_name = 'water'
    local fish_entity_name = 'fish'

    local center_x = left_top.x + config.grid_size / 2
    local center_y = left_top.y + config.grid_size / 2
    local pond_size = 3

    for x = -pond_size, pond_size do
        for y = -pond_size, pond_size do
            local p = {x = center_x + x, y = center_y + y}
            surface.set_tiles({{name = water_tile_name, position = p}}, true)
        end
    end
end


local cell_helper = {
    draw_cell_by_coords = draw_cell_by_coords;

    draw_starting_cell = draw_starting_cell;
}

return cell_helper