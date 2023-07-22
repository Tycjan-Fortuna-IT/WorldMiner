local Map = require("core.functions.map_helper")

local function on_player_joined_game(event)
    local player = game.players[event.player_index]

    if player.online_time == 0 then
        local tick_delay = game.tick + 60

        script.on_event(defines.events.on_tick, function(event)
            if event.tick >= tick_delay then

                player.insert{name = "iron-plate", count = 400}

                script.on_event(defines.events.on_tick, nil)
            end
        end)
    end
end


script.on_init(Map.on_init)
script.on_event(defines.events.on_player_joined_game, on_player_joined_game)
script.on_event(defines.events.on_player_changed_position, Map.on_player_changed_position)
script.on_event(defines.events.on_chunk_generated, Map.on_chunk_generated)