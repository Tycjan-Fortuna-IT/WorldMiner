local utils = require("core.utils.utils")
local config = require("core.config.config")
local rooms1x1 = require("core.variants.1x1")

local rock_raffle = { 'rock-huge', 'rock-big', 'rock-big', 'rock-big' }

local function init_cell(cell_position)
    local cell_coords = utils.coord_to_string(cell_position)

    global.map_cells[cell_coords] = global.map_cells[cell_coords] or {}
    global.map_cells[cell_coords].visited = global.map_cells[cell_coords].visited or true
end

local function get_chunk_position(position)
    local chunk_position = {}

    position.x = math.floor(position.x, 0)
    position.y = math.floor(position.y, 0)

    for x = 0, 31, 1 do
        if (position.x - x) % 32 == 0 then
            chunk_position.x = (position.x - x) / 32
        end
    end

    for y = 0, 31, 1 do
        if (position.y - y) % 32 == 0 then
            chunk_position.y = (position.y - y) / 32
        end
    end

    return chunk_position
end

local function regenerate_decoratives(surface, position)
    local chunk = get_chunk_position(position)

    if not chunk then
        return
    end

    surface.destroy_decoratives({ area = { { chunk.x * 32, chunk.y * 32 }, { chunk.x * 32 + 32, chunk.y * 32 + 32 } } })

    local decorative_names = {}

    for k, v in pairs(game.decorative_prototypes) do
        if v.autoplace_specification then
            decorative_names[#decorative_names + 1] = k
        end
    end

    surface.regenerate_decorative(decorative_names, { chunk })
end

local function draw_cell_by_coords(cell_coords)
    local surface = game.surfaces.nauvis

    if global.map_cells[utils.coord_to_string(cell_coords)] then
        if global.map_cells[utils.coord_to_string(cell_coords)].visited then
            return
        end
    end

    utils.select_random_room(rooms1x1)(surface, { x = cell_coords[1], y = cell_coords[2] }, 0)

    init_cell(cell_coords)

    regenerate_decoratives(surface, { x = cell_coords[1] * config.grid_size, y = cell_coords[2] * config.grid_size })

    global.discovered_cells = global.discovered_cells + 1
end

local function draw_starting_cell(surface, left_top)
    for x = 0, 31, 1 do
        for y = 0, 31, 1 do
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

    init_cell({ 0, 0 })

    global.map_cells[utils.coord_to_string({ 0, 0 })].visited = true
end

local cell_helper = {
    draw_cell_by_coords = draw_cell_by_coords,

    draw_starting_cell = draw_starting_cell,
}

return cell_helper
