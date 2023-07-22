local kustom_maf = require("core.utils.math")
local map_config = require("core.config.config")
local cell_helper = require("core.helpers.cell_helper")
local rocks_yield_ore = require("core.features.rocks_yield_ore")

------------------------------------------------------------------------------------

local function on_init(event)
    global.map_cells = {}
    global.map_depth = 0

    remote.call("freeplay", "set_disable_crashsite", true)
    remote.call("freeplay", "set_skip_intro", true)
    game.forces['player'].set_spawn_position({ map_config.grid_size / 2, map_config.grid_size / 2 }, game.surfaces
    .nauvis)

    rocks_yield_ore.on_init()
end

local function on_chunk_generated(event)
    local surface = event.surface
    local left_top = event.area.left_top

    if left_top.x == 0 and left_top.y == 0 then
        cell_helper.draw_starting_cell(surface, left_top)

        return
    end

    for x = 0, 31, 1 do
        for y = 0, 31, 1 do
            local p = { x = left_top.x + x, y = left_top.y + y }
            surface.set_tiles({ { name = map_config.void_tile, position = p } }, true)
        end
    end
end

local function on_player_changed_position(event)
    local player = game.players[event.player_index]

    local player_position = kustom_maf.get_cell_by_position(player.position)

    if player.position.x / map_config.grid_size - player_position.x >= 0.95 then
        cell_helper.draw_cell_by_coords({ player_position.x + 1, player_position.y })
    elseif player.position.x / map_config.grid_size - player_position.x <= 0.05 then
        cell_helper.draw_cell_by_coords({ player_position.x - 1, player_position.y })
    elseif player.position.y / map_config.grid_size - player_position.y >= 0.95 then
        cell_helper.draw_cell_by_coords({ player_position.x, player_position.y + 1 })
    elseif player.position.y / map_config.grid_size - player_position.y <= 0.05 then
        cell_helper.draw_cell_by_coords({ player_position.x, player_position.y - 1 })
    end
end

local function on_configuration_changed()
    rocks_yield_ore.on_configuration_changed()
end

local function on_player_mined_entity(event)
    rocks_yield_ore.on_player_mined_entity(event)
end

local function on_entity_died(entity)
    rocks_yield_ore.on_entity_died(entity)
end

local map_helper = {
    on_init = on_init,
    on_configuration_changed = on_configuration_changed,
    on_chunk_generated = on_chunk_generated,
    on_player_changed_position = on_player_changed_position,
    on_player_mined_entity = on_player_mined_entity,
    on_entity_died = on_entity_died,
}

return map_helper;
