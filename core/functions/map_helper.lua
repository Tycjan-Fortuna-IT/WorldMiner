local kustom_maf = require("core.utils.math")

local map_config = require("core.config.config")

------------------------------------------------------------------------------------

local function on_init(event)
    global.map_cells = {}
    global.map_depth = 0

    remote.call("freeplay", "set_disable_crashsite", true)
    remote.call("freeplay", "set_skip_intro", true)
    game.forces['player'].set_spawn_position({map_config.grid_size / 2, map_config.grid_size / 2}, game.surfaces.nauvis)
end

local function init_cell(cell_position)
    local cell_coords = kustom_maf.coord_to_string(cell_position)

    global.map_cells[cell_coords] = global.map_cells[cell_coords] or {}
    global.map_cells[cell_coords].visited = global.map_cells[cell_coords].visited or false
end

local function on_chunk_generated(event)
    local surface = event.surface
    local left_top = event.area.left_top

    if left_top.x == 0 and left_top.y == 0 then
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

        return
    end

    for x = 0, 31, 1 do
        for y = 0, 31, 1 do
            local p = {x = left_top.x + x, y = left_top.y + y}
            surface.set_tiles({{name = map_config.void_tile, position = p}}, true)
        end
    end
end

local function on_player_changed_position(event)
    local player = game.players[event.player_index]

    local player_position = kustom_maf.get_cell_by_position(player.position)

    if player.position.x / map_config.grid_size - player_position.x >= 0.95 then
        game.print("right")
    elseif player.position.x / map_config.grid_size - player_position.x <= 0.05 then
        game.print("left")
    elseif player.position.y / map_config.grid_size - player_position.y >= 0.95 then
        game.print("down")
    elseif player.position.y / map_config.grid_size - player_position.y <= 0.05 then
        game.print("up")
    end
end

local maze_helper = {
    on_init = on_init;
    on_chunk_generated = on_chunk_generated;
    on_player_changed_position = on_player_changed_position;
}

return maze_helper;