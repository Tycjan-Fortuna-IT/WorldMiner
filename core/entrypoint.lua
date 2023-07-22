local Map = require("core.functions.map_helper")

script.on_init(Map.on_init)
script.on_configuration_changed(Map.on_configuration_changed)

script.on_event(defines.events.on_player_changed_position, Map.on_player_changed_position)
script.on_event(defines.events.on_chunk_generated, Map.on_chunk_generated)
script.on_event(defines.events.on_player_mined_entity, Map.on_player_mined_entity)
