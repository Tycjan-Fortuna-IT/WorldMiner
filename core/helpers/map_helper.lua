local utils = require("core.utils.utils")
local map_config = require("core.config.config")
local cell_helper = require("core.helpers.cell_helper")
local rocks_yield_ore = require("core.features.rocks_yield_ore")
local rocks_yield_coins = require("core.features.rocks_yield_coins")
local gui = require("core.gui.gui")
local market = require("core.features.market")
local config = require("core.config.config")
local rocks_yield_enemies = require("core.features.rocks_yield_enemies")
local trees_yield_ore     = require("core.features.trees_yield_ore")
local rocks_yield_loot = require("core.features.rocks_yield_loot")
local variant_dispatcher = require("core.variants.variant_dispatcher")


local map_helper = {}

map_helper.on_init = function (event)
    global.map_cells = {}
    global.discovered_cells = 1
    global.discovered_rooms = 1
    global.fluids_placed = {}
    global.player_stats = {}
    global.variants = {}
    
    remote.call("freeplay", "set_disable_crashsite", true)
    remote.call("freeplay", "set_skip_intro", true)
    game.forces['player'].set_spawn_position({ map_config.grid_size / 2 - 5, map_config.grid_size / 2 - 5 }, game.surfaces.nauvis)
    
    config.on_init()
    map_config.on_init()
    rocks_yield_ore.on_init()
end

map_helper.on_load = function ()
    variant_dispatcher.on_load()
end

map_helper.on_chunk_generated = function(event)
    local surface = event.surface
    local left_top = event.area.left_top

    if left_top.x == 0 and left_top.y == 0 then
        cell_helper.draw_starting_cell(surface, left_top)

        local center_x = left_top.x + config.grid_size / 2
        local center_y = left_top.y + config.grid_size / 2

        market.build({ center_x, center_y })

        return
    end

    local tiles = {}

    for i = 0, 1023 do
        table.insert(tiles, { name = map_config.void_tile, position = { x = left_top.x + i % 32, y = left_top.y + math.floor(i / 32) } })
    end
    
    surface.set_tiles(tiles)
end

map_helper.on_player_changed_position = function (event)
    local player = game.players[event.player_index]

    local player_position = utils.get_cell_by_position(player.position)

    if player.position.x / map_config.grid_size - player_position.x >= 0.90 then
        cell_helper.draw_cell_by_coords({ x = player_position.x + 1, y = player_position.y }, defines.direction.east)
    elseif player.position.x / map_config.grid_size - player_position.x <= 0.1 then
        cell_helper.draw_cell_by_coords({ x = player_position.x - 1, y = player_position.y }, defines.direction.west)
    elseif player.position.y / map_config.grid_size - player_position.y >= 0.90 then
        cell_helper.draw_cell_by_coords({ x = player_position.x, y = player_position.y + 1 }, defines.direction.south)
    elseif player.position.y / map_config.grid_size - player_position.y <= 0.1 then
        cell_helper.draw_cell_by_coords({ x = player_position.x, y = player_position.y - 1 }, defines.direction.north)
    end
end

map_helper.on_configuration_changed = function ()
    if not global.config then config.on_init() end

    variant_dispatcher.on_init()
    rocks_yield_ore.on_configuration_changed()
end

map_helper.on_player_mined_entity = function (event)
    rocks_yield_coins.on_player_mined_entity(event)
    rocks_yield_enemies.on_player_mined_entity(event)
    rocks_yield_ore.on_player_mined_entity(event)
    trees_yield_ore.on_player_mined_entity(event)
    rocks_yield_loot.on_player_mined_entity(event)

    event.entity.destroy()
end

map_helper.on_entity_died = function (entity)
    rocks_yield_ore.on_entity_died(entity)
end

map_helper.on_market_item_purchased = function (event)
    market.on_market_item_purchased(event)
end

map_helper.on_tick = function (event)
    -- TODO Make gui refresh-able
    -- if game.tick % 300 == 0 then
    --     gui.refresh()
    -- end
end

map_helper.on_gui_click = function (event)
    gui.on_click(event)
end

map_helper.on_player_joined_game = function (event)
    gui.refresh()
end

return map_helper;
