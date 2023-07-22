local kustom_maf = require("core.utils.math")
local map_config = require("core.config.config")

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

    for x = 0, map_config.grid_size - 1 do
        for y = 0, map_config.grid_size - 1 do
            local tile_name = map_config.void_tile
            if x < map_config.grid_size and y < map_config.grid_size then
                tile_name = map_config.base_tile
            end

            local p = {x = cell_coords[1] * map_config.grid_size + x, y = cell_coords[2] * map_config.grid_size + y}
            
            surface.set_tiles({{name = tile_name, position = p}}, true)
            surface.create_entity({name = rock_raffle[math.random(1, #rock_raffle)], position = p})
        end
    end

    init_cell(cell_coords)
end

local function draw_starting_cell(surface, left_top)
    for x = 0, 31, 1 do
        for y = 0, 31, 1 do
            local tile_name = map_config.void_tile

            if x < map_config.grid_size and y < map_config.grid_size then
                tile_name = map_config.base_tile
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
end

local cell_helper = {
    draw_cell_by_coords = draw_cell_by_coords;

    draw_starting_cell = draw_starting_cell;
}

return cell_helper