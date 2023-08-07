local utils = require("core.utils.utils")
local map_config = require("core.config.config")
local cell_helper = require("core.helpers.cell_helper")
local rocks_yield_ore = require("core.features.rocks_yield_ore")
local rocks_yield_coins = require("core.features.rocks_yield_coins")
local gui = require("core.gui.gui")
local market = require("core.features.market")
local config = require("core.config.config")
local rooms1x1 = require("core.variants.1x1")
local rocks_yield_enemies = require("core.features.rocks_yield_enemies")
local trees_yield_ore     = require("core.features.trees_yield_ore")
local rocks_yield_loot = require("core.features.rocks_yield_loot")
local variant_dispatcher = require("core.variants.variant_dispatcher")
------------------------------------------------------------------------------------

local function on_init(event)
    global.map_cells = {}
    global.discovered_cells = 1
    global.discovered_rooms = 1
    global.fluids_placed = {}
    global.player_stats = {}
    global.variants = {}

    remote.call("freeplay", "set_disable_crashsite", true)
    remote.call("freeplay", "set_skip_intro", true)
    game.forces['player'].set_spawn_position({ map_config.grid_size / 2 - 5, map_config.grid_size / 2 - 5 }, game.surfaces.nauvis)

    map_config.on_init()
    rocks_yield_ore.on_init()
end

local function on_load()
    variant_dispatcher.init()
end

-- without support for custom grid size
local function on_chunk_generated(event)
    local surface = event.surface
    local left_top = event.area.left_top

    if left_top.x == 0 and left_top.y == 0 then
        cell_helper.draw_starting_cell(surface, left_top)

        local center_x = left_top.x + config.grid_size / 2
        local center_y = left_top.y + config.grid_size / 2

        market.build({ center_x, center_y })

        -- game.players[1].insert({ name = "blue-crystal", count = 2000 })

        return
    end

    local tiles = {}

    for i = 0, 1023 do
        table.insert(tiles, { name = map_config.void_tile, position = { x = left_top.x + i % 32, y = left_top.y + math.floor(i / 32) } })
    end
    
    surface.set_tiles(tiles)
end

-- with support for custom grid size
-- local function on_chunk_generated(event)
--     local surface = event.surface
--     local area = event.area
--     local left_top = area.left_top
--     local right_bottom = { x = area.right_bottom.x + config.grid_size, y = area.right_bottom.y + config.grid_size }

--     local grid_size = config.grid_size

    
--     local center_x = grid_size / 2
--     local center_y = grid_size / 2

--     if left_top.x == 0 and left_top.y == 0 then
--         cell_helper.draw_starting_cell(surface, left_top)
--         market.build({ center_x, center_y })
--         return
--     end

--     local tiles = {}
--     local base_tile_count = 0
--     for x = left_top.x, right_bottom.x, 1 do
--         for y = left_top.y, right_bottom.y, 1 do
--             local p = { x = x, y = y }
--             if x < center_x - grid_size / 2 or x >= center_x + grid_size / 2 or
--                 y < center_y - grid_size / 2 or y >= center_y + grid_size / 2 then
--                 tiles[#tiles + 1] = { name = map_config.void_tile, position = p }
--             end
--         end
--     end

--     surface.set_tiles(tiles)
-- end


local function on_player_changed_position(event)
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

local function on_configuration_changed()
    game.print('Expore world chunk by chunk, mine rocks for resources/coins, and build your factory!', {r = 255, g = 255, b = 50})
    game.print('You will find chunks with rocks, trees, water, oil, ore veins, enemies and many more! ...', {r = 255, g = 255, b = 50})

    variant_dispatcher.init()
    rocks_yield_ore.on_configuration_changed()
end

local function on_player_mined_entity(event)
    rocks_yield_coins.on_player_mined_entity(event)
    rocks_yield_enemies.on_player_mined_entity(event)
    rocks_yield_ore.on_player_mined_entity(event)
    trees_yield_ore.on_player_mined_entity(event)
    rocks_yield_loot.on_player_mined_entity(event)

    event.entity.destroy()
end

local function on_entity_died(entity)
    rocks_yield_ore.on_entity_died(entity)
end

local function on_market_item_purchased(event)
    market.on_market_item_purchased(event)
end

local function on_tick(event)
    if game.tick % 300 == 0 then
        gui.refresh_gui()
    end
end

local function on_gui_click(event)
    gui.on_gui_click(event)
end

local map_helper = {
    on_init = on_init,
    on_load = on_load,
    on_configuration_changed = on_configuration_changed,
    on_chunk_generated = on_chunk_generated,
    on_player_changed_position = on_player_changed_position,
    on_player_mined_entity = on_player_mined_entity,
    on_entity_died = on_entity_died,
    on_tick = on_tick,
    on_market_item_purchased = on_market_item_purchased,
    on_gui_click = on_gui_click,
}

return map_helper;
