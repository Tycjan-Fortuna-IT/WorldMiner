local constants = require('core.utils.constants')


local gui = {}

gui.create_cave_miner_stats_toggle_button = function (player)
    if player.gui.top['caver_miner_stats_toggle_button'] then
        player.gui.top['caver_miner_stats_toggle_button'].destroy()
    end

    local b = player.gui.top.add({type = 'sprite-button', name = 'caver_miner_stats_toggle_button', sprite = 'item/dummy-steel-axe'})
    
    b.style.minimal_height = 38
    b.style.minimal_width = 38
    b.style.padding = 1
end

gui.create_cave_miner_stats_gui = function (player)
    if not player.character then
        return
    end

    if player.gui.top['caver_miner_stats_frame'] then
        player.gui.top['caver_miner_stats_frame'].destroy()
    end

    if not global.player_stats[player.index] then
        global.player_stats[player.index] = {}
        global.player_stats[player.index].pickaxe_tier = 1
    end

    local captions = {}
    local caption_style = {
        {'font', 'default-bold'},
        {'font_color', {r = 0.63, g = 0.63, b = 0.63}},
        {'top_padding', 4},
        {'left_padding', 4},
        {'right_padding', 4},
        {'minimal_width', 0}
    }
    local stat_numbers = {}
    local stat_number_style = {
        {'font', 'default-bold'},
        {'font_color', {r = 0.77, g = 0.77, b = 0.77}},
        {'top_padding', 4},
        {'left_padding', 4},
        {'right_padding', 4},
        {'minimal_width', 0}
    }
    local separators = {}
    local separator_style = {
        {'font', 'default-bold'},
        {'font_color', {r = 0.15, g = 0.15, b = 0.89}},
        {'top_padding', 4},
        {'left_padding', 4},
        {'right_padding', 4},
        {'minimal_width', 0}
    }

    local frame = player.gui.top.add {type = 'frame', name = 'caver_miner_stats_frame'}

    local t = frame.add {type = 'table', column_count = 11}

    captions[1] = t.add {type = 'label', caption = 'Ores mined:'}
    stat_numbers[1] = t.add {type = 'label', caption = global.rocks_yield_ore['ores_mined']}
    separators[1] = t.add {type = 'label', caption = '|'}

    captions[2] = t.add {type = 'label', caption = 'Rocks broken:'}
    stat_numbers[2] = t.add {type = 'label', caption = global.rocks_yield_ore['rocks_broken']}
    separators[2] = t.add {type = 'label', caption = '|'}

    captions[3] = t.add {type = 'label', caption = 'Discovered cells:'}
    stat_numbers[3] = t.add {type = 'label', caption = global.discovered_cells}
    separators[3] = t.add {type = 'label', caption = '|'}

    captions[4] = t.add {type = 'label', caption = 'Pickaxe tier:'}
    stat_numbers[4] = t.add {type = 'label', caption = constants.pickaxe_tiers[global.player_stats[player.index].pickaxe_tier]}

    for _, s in pairs(caption_style) do
        for _, l in pairs(captions) do
            l.style[s[1]] = s[2]
        end
    end
    for _, s in pairs(stat_number_style) do
        for _, l in pairs(stat_numbers) do
            l.style[s[1]] = s[2]
        end
    end
    for _, s in pairs(separator_style) do
        for _, l in pairs(separators) do
            l.style[s[1]] = s[2]
        end
    end
    stat_numbers[1].style.minimal_width = 9 * string.len(tostring(global.rocks_yield_ore['ores_mined']))
    stat_numbers[2].style.minimal_width = 9 * string.len(tostring(global.rocks_yield_ore['rocks_broken']))
    stat_numbers[3].style.minimal_width = 9 * string.len(tostring(global.discovered_cells))
end

gui.refresh_gui = function ()
    for _, player in pairs(game.connected_players) do
        gui.create_cave_miner_stats_toggle_button(player)
        if (player.gui.top['caver_miner_stats_frame']) then
            gui.create_cave_miner_stats_gui(player)
        end
    end
end

gui.on_gui_click = function (event)
    if not event then return end
    if not event.element then return end
    if not event.element.valid then return end

    local player = game.players[event.element.player_index]
    local name = event.element.name
    local frame = player.gui.top['caver_miner_stats_frame']

    if name == 'caver_miner_stats_toggle_button' and frame == nil then
        gui.create_cave_miner_stats_gui(player)
    elseif name == 'caver_miner_stats_toggle_button' and frame then
        if player.gui.top['caver_miner_stats_frame'] then
            frame.destroy()
        else
            gui.create_cave_miner_stats_gui(player)
        end
    end
end

return gui