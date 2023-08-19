local gui_helper = require('core.gui.gui_helper')


--- @class ModInfoPanel
local mod_info_panel = {}

--- Creates the mod info GUI.
--- @param player LuaPlayer
--- @return nil
mod_info_panel.create = function(player)
    mod_info_panel.data = {
        name = 'Mod Info',
        caption = 'World Miner  (Work in progress)',
        info = "Welcome to the adventurous world of World Miner! Embark on an exciting journey where you'll explore world chunkby chunk, to uncover precious resources, valuable rocks yielding rare ores and lurking dangers. Delve deep into the unknown, mine your way through rocky terrains. If you like to mine stone extensively this mod is for you.",
        variants = "Available variants to be explored: 1x1, 1x2, 1x3, 2x2, 2x3, 3x3, L, O, T",
        resources = "As you venture further, you'll get more resources from mining stones and, if enabled, harvesting trees. Additionally, ore veins become richer. However, be prepared for an increase in the number of enemies you encounter as you progress",
        upgrades = "Pickaxe upgrades are available to make mining faster. Backpack upgrades are available to increase inventory size.",
        balance_issues = "This mod is still in development and may have balance issues. Please report any issues or suggestions on the mod portal.",
    }
end

--- Draws the mod info GUI.
--- @param panel_frame LuaGuiElement The frame to draw the mod info GUI in.
--- @param player LuaPlayer
--- @return nil
mod_info_panel.draw = function(panel_frame, player)
    panel_frame.clear()
    panel_frame.style.padding = 4
    panel_frame.style.margin = 0

    local t = panel_frame.add({
        type = 'table',
        column_count = 1
    })

    gui_helper
        .add_line(t, {})
        .add_label(t, mod_info_panel.data.caption, {
            font = 'heading-1',
            font_color = { r = 0.5, g = 0.3, b = 0.1 },
        })
        .add_line(t, {})
        .add_label(t, mod_info_panel.data.info, {})
        .add_line(t, {})
        .add_label(t, mod_info_panel.data.variants, {})
        .add_line(t, {})
        .add_label(t, mod_info_panel.data.resources, {})
        .add_line(t, {})
        .add_label(t, mod_info_panel.data.upgrades, {})
        .add_line(t, {})
        .add_label(t, mod_info_panel.data.balance_issues, {})
end

return mod_info_panel
