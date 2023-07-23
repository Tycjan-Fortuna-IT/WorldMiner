local map_helper = require("core.helpers.map_helper")
local gui = require("core.gui.gui")

script.on_init(map_helper.on_init)
script.on_configuration_changed(map_helper.on_configuration_changed)

script.on_event(defines.events.on_entity_died, map_helper.on_entity_died)
script.on_event(defines.events.on_player_changed_position, map_helper.on_player_changed_position)
script.on_event(defines.events.on_chunk_generated, map_helper.on_chunk_generated)
script.on_event(defines.events.on_player_mined_entity, map_helper.on_player_mined_entity)
script.on_event(defines.events.on_tick, map_helper.on_tick)
script.on_event(defines.events.on_market_item_purchased, map_helper.on_market_item_purchased)
