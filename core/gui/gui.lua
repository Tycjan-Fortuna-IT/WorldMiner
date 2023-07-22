local function create_cave_miner_stats_gui(player)
    if not player.character then
        return
    end
    if player.gui.top['caver_miner_stats_frame'] then
        player.gui.top['caver_miner_stats_frame'].destroy()
    end

    local captions = {}
    local caption_style = {
        {'font', 'default-bold'},
        {'font_color', {r = 0.63, g = 0.63, b = 0.63}},
        {'top_padding', 2},
        {'left_padding', 0},
        {'right_padding', 0},
        {'minimal_width', 0}
    }
    local stat_numbers = {}
    local stat_number_style = {
        {'font', 'default-bold'},
        {'font_color', {r = 0.77, g = 0.77, b = 0.77}},
        {'top_padding', 2},
        {'left_padding', 0},
        {'right_padding', 0},
        {'minimal_width', 0}
    }
    local separators = {}
    local separator_style = {
        {'font', 'default-bold'},
        {'font_color', {r = 0.15, g = 0.15, b = 0.89}},
        {'top_padding', 2},
        {'left_padding', 2},
        {'right_padding', 2},
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
end

local function refresh_gui()
    for _, player in pairs(game.connected_players) do
        local frame = player.gui.top['caver_miner_stats_frame']
        if (frame) then
            create_cave_miner_stats_gui(player)
        end
    end
end

local gui = {
    create_cave_miner_stats_gui = create_cave_miner_stats_gui,
    refresh_gui = refresh_gui
}

return gui