local C = require('core.utils.constants')
local gui_helper = require('core.gui.gui_helper')


--- @class StatsPanel
local stats_panel = {}

--- Creates the stats GUI.
--- @param player LuaPlayer
--- @return nil
stats_panel.create = function (player)
    stats_panel.data = {
        name = 'Stats'
    }
end

--- Draws the stats GUI.
--- @param panel_frame LuaGuiElement The frame to draw the stats GUI in.
--- @param player LuaPlayer
--- @return nil
stats_panel.draw = function (panel_frame, player)
    if not global.player_stats[player.index] then
        global.player_stats[player.index] = {}
        global.player_stats[player.index].pickaxe_tier = 1
    end

    local px_tier = global.player_stats[player.index].pickaxe_tier

    local string = ''
    for name, variant in pairs(global.variants) do
        if name == 'dungeon' then goto continue end

        string = string .. 'Variant ' .. name .. ': ' .. (variant.discovered_rooms - 1 or 0) .. ',    '

        ::continue::
    end

    gui_helper
        .add_line(panel_frame, {})
        .add_label(panel_frame, stats_panel.data.name, {
            font = 'heading-1',
            font_color = { r = 0.5, g = 0.3, b = 0.1 },
        })
        .add_line(panel_frame, {})
        .add_label(panel_frame, "Ores mined: " .. global.rocks_yield_ore['ores_mined'], {})
        .add_line(panel_frame, {})
        .add_label(panel_frame, "Rocks broken: " .. global.rocks_yield_ore['rocks_broken'], {})
        .add_line(panel_frame, {})
        .add_label(panel_frame, "Pickaxe tier: " .. C.pickaxe_tiers[px_tier] .. '(' .. px_tier .. ')', {})
        .add_line(panel_frame, {})
        .add_label(panel_frame, "Discovered cells: " .. global.discovered_cells, {})
        .add_line(panel_frame, {})
        .add_label(panel_frame, string, {})
end

return stats_panel